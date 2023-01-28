{ lib, stdenv, autoreconfHook, fetchFromGitHub, fetchpatch, fdk_aac }:

stdenv.mkDerivation rec {
  pname = "fdkaac";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7a8JlQtMGuMWgU/HePd31/EvtBNc2tBMz8V8NQivuNo=";
  };

  patches = [
    # To be removed when 1.0.4 is released, see https://github.com/nu774/fdkaac/issues/54
    (fetchpatch {
      name = "CVE-2022-37781.patch";
      url = "https://github.com/nu774/fdkaac/commit/ecddb7d63306e01d137d65bbbe7b78c1e779943c.patch";
      sha256 = "sha256-uZPf5tqBmF7VWp1fJcjp5pbYGRfzqgPZpBHpkdWYkV0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ fdk_aac ];

  doCheck = true;

  meta = with lib; {
    description = "Command line encoder frontend for libfdk-aac encoder";
    longDescription = ''
      fdkaac reads linear PCM audio in either WAV, raw PCM, or CAF format,
      and encodes it into either M4A / AAC file.
    '';
    homepage = "https://github.com/nu774/fdkaac";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = [ maintainers.lunik1 ];
  };
}
