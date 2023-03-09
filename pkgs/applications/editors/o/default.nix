{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, pkg-config
, withGui ? true, vte
}:

buildGoModule rec {
  pname = "o";
  version = "2.58.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "o";
    rev = "v${version}";
    hash = "sha256-oYWlciTQ/4mm/gTSQEkD/xPeLfDjIAMksjj1DVodZW4=";
  };

  vendorSha256 = null;

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
  '' + lib.optionalString withGui ''
    make install-gui PREFIX=$out
    wrapProgram $out/bin/og --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://github.com/xyproto/o";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
  };
}
