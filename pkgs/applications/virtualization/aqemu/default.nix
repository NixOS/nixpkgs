{ cmake, fetchFromGitHub, libvncserver, qemu, qtbase, stdenv
}:

stdenv.mkDerivation rec {
  pname = "aqemu";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "tobimensch";
    repo = "aqemu";
    rev = "v${version}";
    sha256 = "1h1mcw8x0jir5p39bs8ka0lcisiyi4jq61fsccgb9hsvl1i8fvk5";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libvncserver qtbase qemu ];

  meta = with stdenv.lib; {
    description = "A virtual machine manager GUI for qemu";
    homepage = https://github.com/tobimensch/aqemu;
    license = licenses.gpl2;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
  };
}
