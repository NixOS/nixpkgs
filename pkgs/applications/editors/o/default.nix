{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, pkg-config
, tcsh
, withGui ? stdenv.isLinux, vte # vte is broken on darwin
}:

buildGoModule rec {
  pname = "o";
  version = "2.56.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "o";
    rev = "v${version}";
    hash = "sha256-mUd2IfTSmpRIurhQy2BI8KAuQyYmBoqpvPnEvnFRc7Y=";
  };

  postPatch = ''
    substituteInPlace ko/main.cpp --replace '/bin/csh' '${tcsh}/bin/tcsh'
  '';

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles makeWrapper pkg-config ];

  buildInputs = lib.optional withGui vte;

  preBuild = "cd v2";

  postInstall = ''
    cd ..
    installManPage o.1
  '' + lib.optionalString withGui ''
    make install-gui PREFIX=$out
    wrapProgram $out/bin/ko --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://github.com/xyproto/o";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
  };
}
