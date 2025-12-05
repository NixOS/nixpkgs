{
  lib,
  anki-utils,
  fetchFromGitHub,
  python3,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "local-audio-yomichan";
  version = "0-unstable-2025-08-07";
  src = fetchFromGitHub {
    owner = "yomidevs";
    repo = "local-audio-yomichan";
    rev = "14d33271303d0f6c99675a0b91f3041c49aba125";
    sparseCheckout = [ "plugin" ];
    hash = "sha256-Ce0ejEWTDMpbhPnOlY18I/hQD4VodkLncvg15VCJ0gI=";
  };
  sourceRoot = "${finalAttrs.src.name}/plugin";
  processUserFiles = ''
    # Addon will try to load extra stuff unless Python package name is "plugin".
    temp=$(mktemp -d)
    ln -s $PWD $temp/plugin
    # Addoon expects `user_files` dir at `$XDG_DATA_HOME/local-audio-yomichan`
    ln -s $PWD/user_files $temp/local-audio-yomichan

    PYTHONPATH=$temp \
    WO_ANKI=1 \
    XDG_DATA_HOME=$temp \
    ${lib.getExe python3} -c \
      "from plugin import db_utils; \
       db_utils.init_db()"
  '';
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
  meta = {
    description = "Run a local audio server for Yomitan";
    longDescription = ''
      This add-on must be configured with an audio collection.

      Example:

      ```nix
      pkgs.ankiAddons.local-audio-yomichan.withConfig {
        userFiles =
          let
            audio-collection =
              pkgs.runCommand "local-yomichan-audio-collection"
                {
                  outputHashMode = "recursive";
                  outputHash = "sha256-NxbcXh2SDPfCd+ZHAWT5JdxRecNbT4Xpo0pxX5/DOfo=";

                  src = pkgs.requireFile {
                    name = "local-yomichan-audio-collection-2023-06-11-opus.tar.xz";
                    url = "https://github.com/yomidevs/local-audio-yomichan?tab=readme-ov-file#steps";
                    sha256 = "1xsxp8iggklv77rj972mqaa1i8f9hvr3ir0r2mwfqcdz4q120hr1";
                  };
                }
                '''
                  mkdir -p $out
                  cd $out
                  tar -xf "$src"
                ''';
          in
          "''${audio-collection}/user_files";
      }
      ```
    '';
    homepage = "https://github.com/yomidevs/local-audio-yomichan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
