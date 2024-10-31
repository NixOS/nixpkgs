{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, zlib
}:

stdenv.mkDerivation rec {
  pname = "axmldec";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ytsutano";
    repo = "axmldec";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-LFDZZbRDa8mQmglgS4DA/OqXp0HJZ2uqg1hbStdgvUw=";
  };

  nativeBuildInputs = [ cmake doxygen ];
  buildInputs = [ boost zlib ];

  meta = with lib; {
    description = "Stand-alone binary AndroidManifest.xml decoder";
    longDescription = ''
      This tool accepts either a binary or a text XML file and prints the
      decoded XML to the standard output or a file. It also allows you to
      extract the decoded AndroidManifest.xml directly from an APK file.
    '';
    homepage = "https://github.com/ytsutano/axmldec";
    changelog = "https://github.com/ytsutano/axmldec/releases/tag/${src.rev}";
    license = licenses.isc;
    mainProgram = "axmldec";
    maintainers = with maintainers; [ franciscod ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
