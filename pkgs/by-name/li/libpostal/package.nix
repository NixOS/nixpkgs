{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libpostal";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "openvenues";
    repo = "libpostal";
    rev = "refs/tags/v${version}";
    hash = "sha256-7G/CjYdVzsrvUFXGODoXgXoRp8txkl5SddcPtgltrjY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--disable-data-download"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--disable-sse2" ];

  meta = with lib; {
    description = "C library for parsing/normalizing street addresses around the world. Powered by statistical NLP and open geo data";
    homepage = "https://github.com/openvenues/libpostal";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    mainProgram = "libpostal_data";
    platforms = platforms.unix;
  };
}
