{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, pkg-config
, withGui ? true, vte
}:

buildGoModule rec {
  pname = "orbiton";
  version = "2.65.10";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    rev = "v${version}";
    hash = "sha256-z81Xled6OFs9tKVJgUnws81C86Vle5XR85f3z96N2Gw=";
  };

  vendorHash = null;

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace "-Wl,--as-needed" ""

    # Requires impure pbcopy and pbpaste
    substituteInPlace v2/pbcopy_test.go \
      --replace TestPBcopy SkipTestPBcopy
  '';

  nativeBuildInputs = [ installShellFiles makeWrapper pkg-config ];

  buildInputs = lib.optional withGui vte;

  preBuild = "cd v2";

  postInstall = ''
    cd ..
    installManPage o.1
    mv $out/bin/{orbiton,o}
  '' + lib.optionalString withGui ''
    make install-gui PREFIX=$out
    wrapProgram $out/bin/og --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://orbiton.zip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "o";
  };
}
