{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "quill-log";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    rev = version;
    hash = "sha256-cOj0p2/YqDtg03jzG3DdCak4Fobrr9zQ2wj+CZ9Rgwk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/odygrd/quill";
    changelog = "https://github.com/odygrd/quill/blob/master/CHANGELOG.md";
    downloadPage = "https://github.com/odygrd/quill";
    description = "Asynchronous Low Latency C++17 Logging Library";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ maintainers.odygrd ];
  };
}
