{ stdenv, buildPythonApplication, fetchPypi, python3Packages }:

buildPythonApplication rec {
  pname = "remarkable-mouse";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k2wjfcgnvb8yqn4c4ddfyyhrvl6hj61kn1ddnyp6ay9vklnw160";
  };

  propagatedBuildInputs = with python3Packages; [ screeninfo paramiko pynput libevdev ];

  meta = with stdenv.lib; {
    description = "A program to use a reMarkable as a graphics tablet";
    homepage = "https://github.com/evidlo/remarkable_mouse";
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
  };
}
