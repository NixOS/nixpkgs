{ lib, fetchFromGitHub, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-jellyfin";
  version = "v1.0.2";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = pname;
    rev = version;
    sha256 = "1ixx3pxf5krhj7jpg0nhxmxvpxzwj79i63a4d58zkpr7baj60iy0";
  };

  propagatedBuildInputs = [ mopidy python3Packages.websocket-client python3Packages.unidecode ];

  # mopidy-jellyfin can't be imported
  # pythonImportsCheck = [ "mopidy-jellyfin" ];

  meta = with lib; {
    homepage = "https://mopidy.com/ext/jellyfin/";
    description = "Mopidy extension for playing music from a Jellyfin Music Server";
    license = licenses.asl20;
    maintainers = with maintainers; [ maintainers.gador ];
  };
}
