{
  fetchurl,
  lib,
  stdenv,
  perl,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "sloccount";
  version = "2.26";

  src = fetchurl {
    url = "https://www.dwheeler.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ayiwfjdh1946asah861ah9269s5xkc8p5fv1wnxs9znyaxs4zzs";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  # Make sure the Flex-generated files are newer than the `.l' files, so that
  # Flex isn't needed to recompile them.
  patchPhase = ''
    for file in *
    do
      if grep -q /usr/bin/perl "$file"
      then
          echo "patching \`$file'..."
          substituteInPlace "$file" --replace \
            "/usr/bin/perl" "${perl}/bin/perl"
      fi
    done

    for file in *.l
    do
      touch "$(echo $file | sed -es'/\.l$/.c/g')"
    done
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = true;
  checkPhase = ''HOME="$TMPDIR" PATH="$PWD:$PATH" make test'';

  preInstall = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    mkdir -p "$out/share/doc"
  '';

  postInstall = ''
    for w in "$out/bin"/*; do
      isScript "$w" || continue
      wrapProgram "$w" --prefix PATH : "$out/bin"
    done
  '';

  meta = {
    description = "Set of tools for counting physical Source Lines of Code (SLOC)";

    longDescription = ''
      This is the home page of "SLOCCount", a set of tools for
      counting physical Source Lines of Code (SLOC) in a large number
      of languages of a potentially large set of programs.  This suite
      of tools was used in my papers More than a Gigabuck: Estimating
      GNU/Linux's Size and Estimating Linux's Size to measure the SLOC
      of entire GNU/Linux distributions, and my essay Linux Kernel
      2.6: It's Worth More!  Others have measured Debian GNU/Linux and
      the Perl CPAN library using this tool suite.
    '';

    license = lib.licenses.gpl2Plus;

    homepage = "https://www.dwheeler.com/sloccount/";

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
