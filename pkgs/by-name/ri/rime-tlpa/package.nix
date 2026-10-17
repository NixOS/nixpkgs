{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  librime,
  rime-prelude,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-tlpa";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "AlanJui";
    repo = "rime-tlpa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kKGdnmCONEtPt5vnA/8dc2y/wyZE7sgI3j4YVuBIFYQ=";
  };

  nativeBuildInputs = [ librime ];
  prePatch = "cp -r ${rime-prelude}/* .";

  buildPhase = ''
    runHook preBuild

    ls ./*.schema.yaml | while read f; do
      rime_deployer --compile "$f"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf build/*.txt > /dev/null 2>&1 || true

    mkdir -p $out/share/rime-data/lua
    mkdir -p $out/share/rime-data/build
    install -Dm644 -t $out/share/rime-data/lua ./*.lua
    install -Dm644 -t $out/share/rime-data/ ./*.schema.yaml ./*.dict.yaml
    install -Dm644 -t $out/share/rime-data/build ./build/*.bin ./build/*.yaml

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rime input method schema for Taiwanese Language Phonetic Alphabet (TLPA)";
    longDescription = ''
      Rime input method schema for Taiwanese Language Phonetic Alphabet (TLPA),
      providing support for inputting Taiwanese Hokkien (Bân-lâm-gú / 閩南語)
      with Pinyin (拼音) romanization system including 台語拼音 (TLPA), 台語拼音二式 (WSL)
      and 閩拼方案 (MP), as well as Zhuyin (注音) and Fanqie (反切) phonetic annotations.
    '';
    homepage = "https://github.com/AlanJui/rime-tlpa";

    # Packages are assumed unfree unless explicitly indicated otherwise
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ maikotan ];
  };
})
