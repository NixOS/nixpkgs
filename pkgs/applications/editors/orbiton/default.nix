{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, pkg-config
, withGui ? true, vte
}:

buildGoModule rec {
  pname = "orbiton";
<<<<<<< HEAD
  version = "2.64.3";
=======
  version = "2.61.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mx6k6OXr3iTCD1FTC7J1fnz7Gs/GyggHXnVywuPo5BY=";
=======
    hash = "sha256-GknQXHwpdIRzSjIc1ITsoiaks4Vi5KmVqL7sHzmfnmQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "https://github.com/xyproto/orbiton";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "o";
  };
}
