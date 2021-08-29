{ lib, stdenv
, fetchFromGitHub
, cmake
, asio
, openssl
, patches
}:

stdenv.mkDerivation {
  pname = "restbed";
  version = "2016-09-15";

  src = fetchFromGitHub {
    owner = "Corvusoft";
    repo = "restbed";
    rev = "34187502642144ab9f749ab40f5cdbd8cb17a54a";
    sha256 = "1jb38331fcicyiisqdprhq6zwfc6g518fm3l4qw9aiv5k9nqim22";
  };

  inherit patches;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ asio openssl ];

  meta = with lib; {
    description = "HTTP framework for building networked applications";
    longDescription = ''
      HTTP framework for building networked applications that require seamless
      and secure communication, with the flexability to model a range of
      business processes. Targeting mobile, tablet, desktop, and embedded
      production environments.
    '';
    homepage = "https://corvusoft.co.uk/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ taeer ];
    platforms = platforms.linux;
  };
}
