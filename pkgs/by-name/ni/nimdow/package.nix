{ lib, buildNimPackage, fetchFromGitHub, nixosTests, testers }:

buildNimPackage (finalAttrs: {
  pname = "nimdow";

  version = "0.7.37";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-930wDS0UW65QzpUHHOuM25oi/OhFmG0Q7N05ftu7XlI=";
  };

  lockFile = ./lock.json;

  postInstall = ''
    install -D config.default.toml $out/share/nimdow/config.default.toml
    install -D nimdow.desktop $out/share/applications/nimdow.desktop
  '';

  postPatch = ''
    substituteInPlace src/nimdowpkg/config/configloader.nim --replace "/usr/share/nimdow" "$out/share/nimdow"
  '';

  passthru.tests = {
    nimdow = nixosTests.nimdow;
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = with lib;
    finalAttrs.src.meta // {
      description = "Nim based tiling window manager";
      platforms = platforms.linux;
      license = [ licenses.gpl2 ];
      maintainers = [ maintainers.marcusramberg ];
      mainProgram = "nimdow";
    };
})
