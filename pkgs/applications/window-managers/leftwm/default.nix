{ stdenv, fetchFromGitHub, rustPlatform, libX11, libXinerama, makeWrapper }:

let
    rpath = stdenv.lib.makeLibraryPath [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
    sha256 = "0x8cqc7zay19jxy7cshayjjwwjrcblqpmqrxipm2g5hhyjghk6q0";
  };

  cargoSha256 = "1dihgyk9n2jw8rxc89g8ix4q98sj9ci242vmk7fa5ahjv4gzdi0g";

  buildInputs = [ makeWrapper libX11 libXinerama ];

  postInstall = ''
    wrapProgram $out/bin/leftwm --prefix LD_LIBRARY_PATH : "${rpath}"
    wrapProgram $out/bin/leftwm-state --prefix LD_LIBRARY_PATH : "${rpath}"
    wrapProgram $out/bin/leftwm-worker --prefix LD_LIBRARY_PATH : "${rpath}"
  '';

  meta = with stdenv.lib; {
    description = "Leftwm - A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
  };
}
