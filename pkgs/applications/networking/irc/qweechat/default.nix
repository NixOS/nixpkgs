{ stdenv, fetchFromGitHub, python27Packages }:

python27Packages.buildPythonApplication rec {
  version = "2016-07-29";
  name = "qweechat-unstable-${version}";
  namePrefix = "";

 src = fetchFromGitHub {
    owner = "weechat";
    repo = "qweechat";
    rev = "f5e54d01691adb3abef47e051a6412186c33313c";
    sha256 = "0dhlriwvkrsn7jj01p2wqhf2p63n9qd173jsgccgxlacm2zzvhaz";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace 'qweechat = qweechat.qweechat' 'qweechat = qweechat.qweechat:main'
  '';

  propagatedBuildInputs = with python27Packages; [
     pyside
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/weechat/qweechat;
    description = "Qt remote GUI for WeeChat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
