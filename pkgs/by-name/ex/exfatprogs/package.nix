{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  file,
}:

stdenv.mkDerivation rec {
  pname = "exfatprogs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    rev = version;
    sha256 = "sha256-2kD2ZENAyhApYHs6+NNYkxfLj5fw/cIHRUhw0UnQx04=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

  meta = with lib; {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yuannan ];
    platforms = platforms.linux;
  };
}
