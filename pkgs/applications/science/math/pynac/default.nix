{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, flint
, gmp
, python3
, singular
, ncurses
}:

stdenv.mkDerivation rec {
  version = "0.7.27";
  pname = "pynac";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${version}";
    sha256 = "sha256-1HHCIeaNE2UsJNX92UlDGLJS8I4nC/8FnwX7Y4F9HpU=";
  };

  patches = [
    # the five patches below are included with sage 9.3. since pynac
    # is a self-described "Sage Math support library", we include them
    # here.

    # https://trac.sagemath.org/ticket/30688
    (fetchpatch {
      name = "power_inf_loop.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/power_inf_loop.patch?h=9.3";
      sha256 = "sha256-VYeaJl8u2wl7FQ/6xnpZv1KpdNYEmJoPhuMrBADyTRs=";
    })

    # https://trac.sagemath.org/ticket/31479
    (fetchpatch {
      name = "disable_poly_mul_expand.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/disable_poly_mul_expand.patch?h=9.3";
      sha256 = "sha256-gRjoltU9Tzj7fjNyE25fY+iyDxERzSTOMigzxFpUqPo=";
    })

    # https://trac.sagemath.org/ticket/31530
    (fetchpatch {
      name = "too_much_sub.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/too_much_sub.patch?h=9.3";
      sha256 = "sha256-lw7xSQ/l+rzPu+ghWF4omYF0mKksGGPuuHJTktvbdis=";
    })

    # https://trac.sagemath.org/ticket/31554
    (fetchpatch {
      name = "handle_factor.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/handle_factor.patch?h=9.3";
      sha256 = "sha256-U1lb5qwBqZZgklfDMhBX4K5u8bz5x42O4w7hyNy2YVw=";
    })

    # https://trac.sagemath.org/ticket/31645
    (fetchpatch {
      name = "seriesbug.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/seriesbug.patch?h=9.3";
      sha256 = "sha256-b3//oirN7JHDYqrvE+tDYcnKpSYQJ08yBzcNlII2Dts=";
    })
  ];

  buildInputs = [
    flint
    gmp
    singular
    python3
    ncurses
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Python is Not a CAS -- modified version of Ginac";
    longDescription = ''
      Pynac -- "Python is Not a CAS" is a modified version of Ginac that
      replaces the depency of GiNaC on CLN by a dependency instead of Python.
      It is a lite version of GiNaC as well, not implementing all the features
      of the full GiNaC, and it is *only* meant to be used as a Python library.
    '';
    homepage    = "http://pynac.org";
    license = licenses.gpl3;
    maintainers = teams.sage.members;
    platforms   = platforms.unix;
  };
}
