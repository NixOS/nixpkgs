
{ stdenv, fetchurl, cmake,
  singlePrec ? true,
  fftw
}:


let meta = import ./meta.nix;
in

stdenv.mkDerivation {
    name = "gromacs-4.5.5";

    src = fetchurl {
        url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.5.5.tar.gz";
	md5 = "6a87e7cdfb25d81afa9fea073eb28468";
    };

    buildInputs = [cmake fftw];

    cmakeFlags = ''
      ${if singlePrec then "-DGMX_DOUBLE=OFF" else "-DGMX_DOUBLE=ON -DGMX_DEFAULT_SUFFIX=OFF"}
    '';

    inherit meta;
}
