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
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-AwY5TkQRfWjkkcleymNN580mKGxIdZ0O30tt6yBbo5M=";
=======
    sha256 = "sha256-2kD2ZENAyhApYHs6+NNYkxfLj5fw/cIHRUhw0UnQx04=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

<<<<<<< HEAD
  meta = {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ yuannan ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yuannan ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
