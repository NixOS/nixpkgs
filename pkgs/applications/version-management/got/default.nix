{ lib, stdenv, fetchurl, pkg-config, openssl, libbsd, libuuid, libossp_uuid, libmd, zlib, ncurses }:

stdenv.mkDerivation rec {
  pname = "got";
  version = "0.74";

  src = fetchurl {
    url = "https://gameoftrees.org/releases/portable/got-portable-${version}.tar.gz";
    sha256 = "sha256-XElSCdFh24rf2gosjS0BG+VNqLZNLYeYkUy4t5RIdv4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl libbsd libuuid libmd zlib ncurses ]
  ++ lib.optionals stdenv.isDarwin [ libossp_uuid ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    test "$($out/bin/got --version)" = '${pname} ${version}'
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A version control system which prioritizes ease of use and simplicity over flexibility";
    longDescription = ''
      Game of Trees (Got) is a version control system which prioritizes
      ease of use and simplicity over flexibility.

      Got uses Git repositories to store versioned data. Git can be used
      for any functionality which has not yet been implemented in
      Got. It will always remain possible to work with both Got and Git
      on the same repository.
    '';
    homepage = "https://gameoftrees.org";
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbe ];
  };
}
