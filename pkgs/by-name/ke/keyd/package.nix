{ stdenv
, lib
, fetchFromGitHub
, systemd
, runtimeShell
, python3
, nixosTests
}:

let
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-pylfQjTnXiSzKPRJh9Jli1hhin/MIGIkZxLKxqlReVo=";
  };

  pypkgs = python3.pkgs;

  appMap = pypkgs.buildPythonApplication rec {
    pname = "keyd-application-mapper";
    inherit version src;
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

  # post-2.4.2 may need this to unbreak the test
  # makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];

  postInstall = ''
    ln -sf ${lib.getExe appMap} $out/bin/${appMap.pname}
    rm -rf $out/etc
  '';

  passthru.tests.keyd = nixosTests.keyd;

  meta = with lib; {
    description = "Key remapping daemon for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ alfarel ];
    platforms = platforms.linux;
  };
}
