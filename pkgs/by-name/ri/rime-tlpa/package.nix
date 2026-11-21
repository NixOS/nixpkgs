{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-tlpa";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AlanJui";
    repo = "rime-tlpa";
    rev = "a54b48207f3e075bc96a59f46040b78ed3e9a4ba";
    hash = "sha256-1QFiazZBuWk++AODeqaz8A1U9eYE8rzD57K8LAVXSBg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/lua
    install -Dm644 -t $out/share/rime-data/ ./*.yaml ./*.lua
    if ls ./lua/*.lua >/dev/null 2>&1; then
      install -Dm644 -t $out/share/rime-data/lua ./lua/*.lua
    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rime input method schema for Taiwanese Language Phonetic Alphabet (TLPA)";
    longDescription = ''
      Rime input method schemas for Taiwanese Hokkien (Bân-lâm-gú / 閩南語).
      Ships 17 schemas grouped into five families:

      - 按鍵練習 (keyboard practice): 方音符號, 國際音標注音, 羅馬拼音字母
      - 拼音輸入法 (romanization): 台語音標 (TLPA), 台羅拼音 (Tâi-lô),
        白話字 (POJ), 閩拼方案 (BP), 台語注音二式 (BPM2)
      - 十五音輸入法 (fifteen-initial): 台語注音二式, 台羅拼音, 方音符號
      - 十八音輸入法 (eighteen-initial): 台語注音二式, 台羅拼音, 方音符號
      - 注音輸入法 (zhuyin): 台語注音符號, 台語注音二式, 方音符號

      Supports phonetic annotation with TLPA+, Tâi-lô, POJ, BP and BPM2,
      as well as extended Bopomofo (方音符號) and IPA, via bundled Lua
      converters for annotated output.
    '';
    homepage = "https://github.com/AlanJui/rime-tlpa";

    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ maikotan ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
