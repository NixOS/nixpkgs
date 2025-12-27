{
  stdenv,
  lib,
  fetchFromGitHub,
  systemd,
  runtimeShell,
  python3,
  nixosTests,
}:
let
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v${version}";
    hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
  };

  appMap =
    let
      pname = "keyd-application-mapper";
      pypkgs = python3.pkgs;
    in
    pypkgs.buildPythonApplication {
      inherit pname version src;
      format = "other";

      postPatch = ''
        substituteInPlace scripts/${pname} \
          --replace-fail /bin/sh ${runtimeShell}
      '';

      propagatedBuildInputs = with pypkgs; [ xlib ];

      dontBuild = true;

      installPhase = ''
        install -Dm555 -t $out/bin scripts/${pname}
      '';

      meta.mainProgram = "keyd-application-mapper";
    };
in
stdenv.mkDerivation {
  pname = "keyd";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local ""

    substituteInPlace keyd.service.in \
      --replace-fail @PREFIX@ $out
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  buildInputs = [ systemd ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf ${lib.getExe appMap} $out/bin/${appMap.pname}
    rm -rf $out/etc
  '';

  passthru.tests.keyd = nixosTests.keyd;

  meta = {
    description = "Key remapping daemon for Linux";
    mainProgram = "keyd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alfarel ];
    platforms = lib.platforms.linux;
  };
}
