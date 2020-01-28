{ stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "dat";
  version = "13.13.1";

  suffix = {
    x86_64-darwin = "macos-x64";
    x86_64-linux  = "linux-x64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/datproject/dat/releases/download/v${version}/${pname}-${version}-${suffix}.zip";
    sha256 = {
      x86_64-darwin = "1qj38zn33hhr2v39jw14k2af091bafh5yvhs91h5dnjb2r8yxnaq";
      x86_64-linux  = "0vgn57kf3j1pbfxlhj4sl1sm2gfd2gcvhk4wz5yf5mzq1vj9ivpv";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  buildInputs = [ unzip ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin
    mv dat $out/bin
  '';

  # dat is a node program packaged using zeit/pkg.
  # thus, it contains hardcoded offsets.
  # patchelf shifts these locations when it expands headers.

  # this could probably be generalised into allowing any program packaged
  # with zeit/pkg to be run on nixos.

  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc];
  in stdenv.lib.optionalString (!stdenv.isDarwin) ''
    orig_size=$(stat --printf=%s $out/bin/dat)

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/dat
    patchelf --set-rpath ${libPath} $out/bin/dat
    chmod +x $out/bin/dat

    new_size=$(stat --printf=%s $out/bin/dat)

    ###### zeit-pkg fixing starts here.
    # we're replacing plaintext js code that looks like
    # PAYLOAD_POSITION = '1234                  ' | 0
    # [...]
    # PRELUDE_POSITION = '1234                  ' | 0
    # ^-----20-chars-----^^------22-chars------^
    # ^-- grep points here
    #
    # var_* are as described above
    # shift_by seems to be safe so long as all patchelf adjustments occur
    # before any locations pointed to by hardcoded offsets

    var_skip=20
    var_select=22
    shift_by=$(expr $new_size - $orig_size)

    function fix_offset {
      # $1 = name of variable to adjust
      location=$(grep -obUam1 "$1" $out/bin/dat | cut -d: -f1)
      location=$(expr $location + $var_skip)

      value=$(dd if=$out/bin/dat iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)

      echo -n $value | dd of=$out/bin/dat bs=1 seek=$location conv=notrunc
    }

    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION
  '';

  meta = with stdenv.lib; {
    description = "Peer-to-peer sharing and live synchronization of files";
    homepage = "https://dat.foundation/";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ prusnak ];
  };
}
