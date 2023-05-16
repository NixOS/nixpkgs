{ lib, stdenv, fetchFromGitHub, rustPlatform
, pkg-config, wrapGAppsHook, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "muso";
<<<<<<< HEAD
  version = "unstable-2021-09-02";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "quebin31";
    repo = pname;
<<<<<<< HEAD
    rev = "6dd1c6d3a82b21d4fb2606accf2f26179eb6eaf9";
    hash = "sha256-09DWUER0ZWQuwfE3sjov2GjJNI7coE3D3E5iUy9mlSE=";
=======
    rev = "68cc90869bcc0f202830a318fbfd6bb9bdb75a39";
    sha256 = "1dnfslliss173igympl7h1zc0qz0g10kf96dwrcj6aglmvvw426p";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  preConfigure = ''
    substituteInPlace lib/utils.rs \
      --replace "/usr/share/muso" "$out/share/muso"
  '';

  postInstall = ''
    mkdir -p $out/share/muso
    cp share/* $out/share/muso/
  '';

<<<<<<< HEAD
  cargoHash = "sha256-+UVUejKCfjC6zdW315wmu7f3A5GmnoQ3rIk8SK6LIRI=";

  meta = with lib; {
    broken = stdenv.isDarwin;
=======
  cargoSha256 = "1hgdzyz005244f2mh97js9ga0a6s2hcd6iydz07f1hmhsh1j2bwy";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "An automatic music sorter (based on ID3 tags)";
    homepage = "https://github.com/quebin31/muso";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ];
  };
}
