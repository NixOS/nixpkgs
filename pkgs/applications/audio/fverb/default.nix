{ stdenv
, fetchFromGitHub
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "fverb";
  # no release yet: https://github.com/jpcima/fverb/issues/2
  version = "unstable-2020-06-09";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "462020e33e24c0204a375dc95e2c28654cc917b8";
    sha256 = "12nl7qn7mnykk7v8q0j2n8kfq0xc46n0i45z6qcywspadwnncmd4";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  meta = with stdenv.lib; {
    description = "A stereo variant of the reverberator by Jon Dattorro, for lv2";
    homepage = "https://github.com/jpcima/fverb";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms   = platforms.unix;
  };
}
