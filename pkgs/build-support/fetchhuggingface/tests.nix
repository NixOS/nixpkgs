{
  lib,
  callPackage,
  testers,
  fetchFromHuggingFace,
  runCommand,
  python3,
  stdenv,
  ...
}:
let
  transformersPython = python3.withPackages (
    ps: with ps; [
      torch
      transformers
    ]
  );

  fetchTestRepository = testers.invalidateFetcherByDrvHash fetchFromHuggingFace;
  fetchFromHuggingFaceSourceNamed = callPackage ./default.nix {
    repoRevToNameMaybe =
      _: _: _:
      "source";
  };

  repoPrefixes = {
    model = "models";
    dataset = "datasets";
    space = "spaces";
  };

  isCommitHash = rev: builtins.match "^[0-9A-Fa-f]{40}$" rev != null;

  # A tiny local stand-in used for validation paths that only need a store
  # directory and should not depend on any remote fetcher.
  fakeRepository = runCommand "fetchFromHuggingFace-fake-repository" { } ''
    mkdir -p "$out"
    touch "$out/placeholder"
  '';

  normalizeRepository =
    repository:
    let
      isRepositoryDerivation = lib.isDerivation repository;
      repositoryAttrs = builtins.isAttrs repository;
      source =
        if isRepositoryDerivation then
          repository
        else if repositoryAttrs then
          repository.src or null
        else
          null;
      repoId =
        if !isRepositoryDerivation && repositoryAttrs && repository ? repoId then
          repository.repoId
        else if source != null then
          source.repoId or null
        else
          null;
      repoType =
        if !isRepositoryDerivation && repositoryAttrs && repository ? repoType then
          repository.repoType
        else if source != null then
          source.repoType or "model"
        else
          "model";
      rev =
        if !isRepositoryDerivation && repositoryAttrs && repository ? rev then
          repository.rev
        else if source != null then
          source.rev or null
        else
          null;
      ref = if !isRepositoryDerivation && repositoryAttrs then repository.ref or "main" else "main";
      parts = if repoId == null then [ ] else lib.splitString "/" repoId;
      validRepoId =
        builtins.length parts >= 1 && builtins.length parts <= 2 && builtins.all (part: part != "") parts;
    in
    assert (
      lib.assertMsg (
        source != null
      ) "fetchFromHuggingFace tests require each repository to be a derivation or an attrset with `src`."
    );
    assert (
      lib.assertMsg (
        repoId != null
      ) "fetchFromHuggingFace tests require `repoId` to be present or inferable from `src`."
    );
    assert (
      lib.assertMsg validRepoId "fetchFromHuggingFace tests require `repoId` to be in the form `repo` or `owner/repo`."
    );
    assert (
      lib.assertMsg (
        rev != null && isCommitHash rev
      ) "fetchFromHuggingFace tests require `rev` to be a 40-character commit hash."
    );
    assert (lib.assertOneOf "repoType" repoType (builtins.attrNames repoPrefixes));
    {
      inherit
        ref
        repoId
        repoType
        rev
        source
        ;
    };

  mkRepositorySetup =
    rawRepository:
    let
      repository = normalizeRepository rawRepository;
      repoCacheId = builtins.concatStringsSep "--" (lib.splitString "/" repository.repoId);
    in
    ''
      repo_cache="$HF_HOME/hub/${repoPrefixes.${repository.repoType}}--${repoCacheId}"
      mkdir -p "$repo_cache/refs" "$repo_cache/snapshots"
      ref_relpath=${lib.escapeShellArg repository.ref}
      ref_path="$repo_cache/refs/$ref_relpath"
      mkdir -p "$(dirname "$ref_path")"
      printf '%s' ${lib.escapeShellArg repository.rev} > "$ref_path"
      ln -s ${lib.escapeShellArg (toString repository.source)} "$repo_cache/snapshots/${repository.rev}"
    '';

  runWithSeededHuggingFaceCache =
    {
      name,
      command,
      repositories,
      runtimeInputs ? [ ],
    }:
    runCommand name { nativeBuildInputs = runtimeInputs; } ''
      export HOME="$PWD/.home"
      export HF_HOME="$HOME/.cache/huggingface"
      export HF_HUB_OFFLINE=1
      export TRANSFORMERS_OFFLINE=1

      mkdir -p "$HF_HOME/hub"

      ${lib.concatLines (map mkRepositorySetup repositories)}

      ${command}
    '';

  # Assert that one seeded repository produced the exact cache entry shape
  # expected by huggingface_hub.
  assertCacheEntry =
    {
      cacheDir,
      rev,
      source,
      ref ? "main",
    }:
    ''
      ref_relpath=${lib.escapeShellArg ref}
      snapshot_rev=${lib.escapeShellArg rev}
      test -d "$HF_HOME/hub/${cacheDir}"
      test "$(cat "$HF_HOME/hub/${cacheDir}/refs/$ref_relpath")" = "$snapshot_rev"
      test "$(readlink "$HF_HOME/hub/${cacheDir}/snapshots/$snapshot_rev")" = "${source}"
    '';
in
let
  self = {
    naming =
      let
        result = fetchFromHuggingFaceSourceNamed {
          repoId = "kitten/named-model";
          rev = "0123456789abcdef0123456789abcdef01234567";
          hash = lib.fakeHash;
        };
      in
      runCommand "fetchFromHuggingFace-name-test" { } ''
        test "${result.name}" = "source"
        touch "$out"
      '';

    unnamespaced =
      let
        source = fetchFromHuggingFace {
          repoId = "gpt2";
          rev = "0123456789abcdef0123456789abcdef01234567";
          hash = lib.fakeHash;
        };
        inferred = builtins.tryEval (
          (runWithSeededHuggingFaceCache {
            name = "fetchFromHuggingFace-unnamespaced-source";
            repositories = [ source ];
            command = ''
              touch "$out"
            '';
          }).drvPath
        );
      in
      runCommand "fetchFromHuggingFace-unnamespaced-test" { } ''
        test "${source.repoId}" = "gpt2"
        test "${if inferred.success then "1" else "0"}" = "1"
        touch "$out"
      '';

    simple = fetchTestRepository {
      repoId = "hf-internal-testing/tiny-random-gpt2";
      rev = "71034c5d8bde858ff824298bdedc65515b97d2b9";
      hash = "sha256-8K9B/C62GW5lXC0c8QQpQ9QAE1UMoG+kYqvGhnWIp64=";
    };

    rootDir = fetchTestRepository {
      repoId = "hf-internal-testing/tiny-random-BertModel";
      rev = "fc08ad9cc33be9aef4f55cc80e16ef5ae3d5981c";
      rootDir = "onnx";
      hash = "sha256-ETm2DT9jvVJ5W3MP8T0RiulNUlXlA2chtc9AVI+u6n4=";
    };

    invalidRepoId =
      let
        result = builtins.tryEval (
          (runWithSeededHuggingFaceCache {
            name = "fetchFromHuggingFace-invalid-repo-id";
            repositories = [
              {
                repoId = "broken/repo/id";
                src = fakeRepository;
                rev = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef";
              }
            ];
            command = ''
              touch "$out"
            '';
          }).drvPath
        );
      in
      runCommand "fetchFromHuggingFace-invalid-repo-id-test" { } ''
        test "${if result.success then "1" else "0"}" = "0"
        touch "$out"
      '';
  };
in
self
// lib.optionalAttrs (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64)) {
  transformersOffline =
    let
      # Use a small causal LM that transformers resolves through huggingface_hub
      # so this test covers the fetcher, the seeded cache layout,
      # and offline text generation through `from_pretrained(model_id)`.
      modelId = "hf-internal-testing/tiny-random-gpt2";
    in
    runWithSeededHuggingFaceCache {
      name = "fetchFromHuggingFace-transformers-offline";
      runtimeInputs = [ transformersPython ];
      repositories = [ self.simple ];
      command = ''
        ${assertCacheEntry {
          cacheDir = "models--hf-internal-testing--tiny-random-gpt2";
          rev = self.simple.rev;
          source = self.simple;
        }}

        python - <<'PY'
        from transformers import AutoModelForCausalLM, AutoTokenizer

        model_id = "${modelId}"
        tokenizer = AutoTokenizer.from_pretrained(model_id)
        model = AutoModelForCausalLM.from_pretrained(model_id)

        inputs = tokenizer("Hello", return_tensors="pt")
        output_ids = model.generate(
            **inputs,
            do_sample=False,
            max_new_tokens=5,
            pad_token_id=tokenizer.eos_token_id,
        )
        generated = tokenizer.decode(output_ids[0], skip_special_tokens=True)

        assert output_ids.shape[1] > inputs["input_ids"].shape[1]
        assert isinstance(generated, str)
        assert generated.strip() != ""
        PY

        touch "$out"
      '';
    };
}
