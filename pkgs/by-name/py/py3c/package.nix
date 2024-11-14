{ lib, stdenv, fetchFromGitHub, python311 }:

stdenv.mkDerivation rec {
  pname = "py3c";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "encukou";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v8+0J56sZVbGdBlOotObUa10/zFMTvfXdMYRsKhyZaY=";
  };

  postPatch = ''
    # clang and gcc-11 complain about 'register' keywords used by
    # python-2.7. Let's avoid blanket -Werror.
    substituteInPlace test/setup.py \
      --replace "'-Werror', " ""
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  doCheck = true;

  nativeCheckInputs = [
    python311
  ];

  checkTarget = "test-python";

  meta = with lib; {
    homepage = "https://github.com/encukou/py3c";
    description = "Python 2/3 compatibility layer for C extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
