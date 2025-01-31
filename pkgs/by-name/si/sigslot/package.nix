{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "sigslot";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "palacaze";
    repo = "sigslot";
    rev = "v${version}";
    hash = "sha256-MKtVZLHp8UfXW8KJ3QjPMhxnt46xV+pA9NMqAX0iqiA=";
  };

  nativeBuildInputs = [ cmake ];

  dontBuild = true;

  meta = with lib; {
    description = "Header-only, thread safe implementation of signal-slots for C++";
    license = licenses.mit;
    homepage = "https://github.com/palacaze/sigslot";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
