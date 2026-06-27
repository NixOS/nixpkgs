{
  lib,
  testers,
  fetchFromHuggingFace,
  runCommand,
  ...
}:
let
  fetchTestRepository = testers.invalidateFetcherByDrvHash fetchFromHuggingFace;
  fakeRev = "0123456789abcdef0123456789abcdef01234567";

  expectEvalFailure =
    name: expr:
    let
      result = builtins.tryEval expr;
    in
    runCommand "${name}-test" { } ''
      test "${if result.success then "1" else "0"}" = "0"
      touch "$out"
    '';
in
{
  apiSurface =
    let
      unnamespaced = fetchFromHuggingFace {
        repoId = "gpt2";
        rev = fakeRev;
        hash = lib.fakeHash;
      };
      tagged = fetchFromHuggingFace {
        repoId = "kitten/tagged-model";
        tag = "v1.0";
        hash = lib.fakeHash;
      };
      dataset = fetchFromHuggingFace {
        repoId = "kitten/dataset";
        repoType = "dataset";
        domain = "hf.example";
        rev = fakeRev;
        hash = lib.fakeHash;
      };
      space = fetchFromHuggingFace {
        repoId = "kitten/space";
        repoType = "space";
        rev = fakeRev;
        fetchLFS = false;
        hash = lib.fakeHash;
        passthru.custom = "value";
      };
      fetchgitOptions = fetchFromHuggingFace {
        repoId = "kitten/fetchgit-options";
        rev = fakeRev;
        branchName = "huggingface";
        deepClone = true;
        fetchLFS = false;
        fetchSubmodules = true;
        fetchTags = true;
        leaveDotGit = true;
        hash = lib.fakeHash;
      };
    in
    runCommand "fetchFromHuggingFace-api-surface-test" { } ''
      test "${unnamespaced.repoId}" = "gpt2"
      test "${unnamespaced.repoType}" = "model"
      test "${unnamespaced.passthru.gitRepoUrl}" = "https://huggingface.co/gpt2.git"
      test "${unnamespaced.meta.homepage}" = "https://huggingface.co/gpt2"
      test "${if unnamespaced.fetchLFS then "1" else "0"}" = "1"

      test "${tagged.tag}" = "v1.0"
      test "${tagged.rev}" = "refs/tags/v1.0"
      test "${tagged.passthru.gitRepoUrl}" = "https://huggingface.co/kitten/tagged-model.git"

      test "${dataset.repoId}" = "kitten/dataset"
      test "${dataset.repoType}" = "dataset"
      test "${dataset.passthru.gitRepoUrl}" = "https://hf.example/datasets/kitten/dataset.git"
      test "${dataset.meta.homepage}" = "https://hf.example/datasets/kitten/dataset"

      test "${space.repoType}" = "space"
      test "${space.passthru.gitRepoUrl}" = "https://huggingface.co/spaces/kitten/space.git"
      test "${if space.fetchLFS then "1" else "0"}" = "0"
      test "${space.passthru.custom}" = "value"

      test "${fetchgitOptions.branchName}" = "huggingface"
      test "${if fetchgitOptions.deepClone then "1" else "0"}" = "1"
      test "${if fetchgitOptions.fetchLFS then "1" else "0"}" = "0"
      test "${if fetchgitOptions.fetchSubmodules then "1" else "0"}" = "1"
      test "${if fetchgitOptions.fetchTags then "1" else "0"}" = "1"
      test "${if fetchgitOptions.leaveDotGit then "1" else "0"}" = "1"

      touch "$out"
    '';

  missingRevOrTag = expectEvalFailure "fetchFromHuggingFace-missing-rev-or-tag" (
    (fetchFromHuggingFace {
      repoId = "gpt2";
      hash = lib.fakeHash;
    }).drvPath
  );

  bothRevAndTag = expectEvalFailure "fetchFromHuggingFace-both-rev-and-tag" (
    (fetchFromHuggingFace {
      repoId = "gpt2";
      rev = fakeRev;
      tag = "main";
      hash = lib.fakeHash;
    }).drvPath
  );

  invalidRepoId = expectEvalFailure "fetchFromHuggingFace-invalid-repo-id" (
    (fetchFromHuggingFace {
      repoId = "broken/repo/id";
      rev = fakeRev;
      hash = lib.fakeHash;
    }).drvPath
  );

  invalidRepoType = expectEvalFailure "fetchFromHuggingFace-invalid-repo-type" (
    (fetchFromHuggingFace {
      repoId = "gpt2";
      repoType = "collection";
      rev = fakeRev;
      hash = lib.fakeHash;
    }).drvPath
  );

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
}
