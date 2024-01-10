{ lib, buildNimPackage, fetchFromGitea }:

buildNimPackage (final: prev: {
  pname = "eris";
  version = "20230722";
  outputs = [ "bin" "out" ];
  requiredNimVersion = 1;
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "nim-eris";
    rev = final.version;
    hash = "sha256-JVl2/PmFVYuD4s9hKoQwVDKUa3PBWK5SBDEmVHVSuig=";
  };
  lockFile = ./lock.json;
  postInstall = ''
    mkdir -p "$bin/share/recoll/filters"
    mv "$bin/bin/rclerislink" "$bin/share/recoll/filters/"

    mkdir -p "$bin/share/applications"
    substitute "eris-open.desktop" "$bin/share/applications/eris-open.desktop"\
      --replace "Exec=eriscmd " "Exec=$bin/bin/eriscmd "

    install -D "eris-link.xml" -t "$bin/share/mime/packages"
    install -D "eris48.png" "$bin/share/icons/hicolor/48x48/apps/eris.png"
  '';
  meta = final.src.meta // {
    homepage = "https://codeberg.org/eris/nim-eris";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eriscmd";
    badPlatforms = lib.platforms.darwin;
  };
})
