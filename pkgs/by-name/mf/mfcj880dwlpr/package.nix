{
  lib,
  stdenv,
  fetchurl,
  pkgsi686Linux,
  dpkg,
  makeWrapper,
  coreutils,
  gnused,
  gawk,
  file,
  cups,
  util-linux,
  xxd,
  runtimeShell,
  ghostscript,
  a2ps,
  bash,
}:

# Why:
# The executable "brprintconf_mfcj880dw" binary is looking for "/opt/brother/Printers/%s/inf/br%sfunc" and "/opt/brother/Printers/%s/inf/br%src".
# Whereby, %s is printf(3) string substitution for stdin's arg0 (the command's own filename) from the 10th char forwards, as a runtime dependency.
# e.g. Say the filename is "0123456789ABCDE", the runtime will be looking for /opt/brother/Printers/ABCDE/inf/brABCDEfunc.
# Presumably, the binary was designed to be deployed under the filename "printconf_mfcj880dw", whereby it will search for "/opt/brother/Printers/mfcj880dw/inf/brmfcj880dwfunc".
# For NixOS, we want to change the string to the store path of brmfcj880dwfunc and brmfcj880dwrc but we're faced with two complications:
# 1. Too little room to specify the nix store path. We can't even take advantage of %s by renaming the file to the store path hash since the variable is too short and can't contain the whole hash.
# 2. The binary needs the directory it's running from to be r/w.
# What:
# As such, we strip the path and substitution altogether, leaving only "brmfcj880dwfunc" and "brmfcj880dwrc", while filling the leftovers with nulls.
# Fully null terminating the cstrings is necessary to keep the array the same size and preventing overflows.
# We then use a shell script to link and execute the binary, func and rc files in a temporary directory.
# How:
# In the package, we dump the raw binary as a string of search-able hex values using hexdump. We execute the substitution with sed. We then convert the hex values back to binary form using xxd.
# We also write a shell script that invoked "mktemp -d" to produce a r/w temporary directory and link what we need in the temporary directory.
# Result:
# The user can run brprintconf_mfcj880dw in the shell.

stdenv.mkDerivation rec {
  pname = "mfcj880dwlpr";
  version = "1.0.0-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf102038/mfcj880dwlpr-${version}.i386.deb";
    sha256 = "1680b301f660a407fe0b69f5de59c7473d2d66dc472a1589b0cd9f51736bfea7";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  dontUnpack = true;

  brprintconf_mfcj880dw_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/usr/bin/brprintconf_mfcj880dw_patched brprintconf_mfcj880dw_patched
    ln -s @out@/opt/brother/Printers/mfcj880dw/inf/brmfcj880dwfunc brmfcj880dwfunc
    ln -s @out@/opt/brother/Printers/mfcj880dw/inf/brmfcj880dwrc brmfcj880dwrc
    ./brprintconf_mfcj880dw_patched "$@"
  '';

  installPhase = ''
    dpkg-deb -x $src $out
    substituteInPlace $out/opt/brother/Printers/mfcj880dw/lpd/filtermfcj880dw \
      --replace-fail /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/mfcj880dw/lpd/psconvertij2 \
      --replace-fail "GHOST_SCRIPT=`which gs`" "GHOST_SCRIPT=${ghostscript}/bin/gs"
    substituteInPlace $out/opt/brother/Printers/mfcj880dw/inf/setupPrintcapij \
      --replace-fail "/opt/brother/Printers" "$out/opt/brother/Printers" \
      --replace-fail "printcap.local" "printcap"

    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 \
      --set-rpath $out/opt/brother/Printers/mfcj880dw/inf:$out/opt/brother/Printers/mfcj880dw/lpd \
      $out/opt/brother/Printers/mfcj880dw/lpd/brmfcj880dwfilter
    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_mfcj880dw

    #stripping the hardcoded path.
    # /opt/brother/Printers/%s/inf/br%sfunc -> brmfcj880dwfunc
    # /opt/brother/Printers/%s/inf/br%src -> brmfcj880dwrc
    ${util-linux}/bin/hexdump -ve '1/1 "%.2X"' $out/usr/bin/brprintconf_mfcj880dw | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F6272257366756E63.62726d66636a383830647766756e6300000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F627225737263.62726d66636a3838306477726300000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/usr/bin/brprintconf_mfcj880dw_patched
    chmod +x $out/usr/bin/brprintconf_mfcj880dw_patched
    #executing from current dir. segfaults if it's not r\w.
    mkdir -p $out/bin
    echo -n "$brprintconf_mfcj880dw_script" > $out/bin/brprintconf_mfcj880dw
    chmod +x $out/bin/brprintconf_mfcj880dw
    substituteInPlace $out/bin/brprintconf_mfcj880dw --replace-fail @out@ $out

    # NOTE: opt/brother/Printers/mfcj880dw/lpd/brmfcj880dwfilter also has cardcoded paths, but we can not simply replace them

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj880dw/lpd/filtermfcj880dw $out/lib/cups/filter/brother_lpdwrapper_mfcj880dw

    wrapProgram $out/opt/brother/Printers/mfcj880dw/lpd/psconvertij2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          gnused
          gawk
        ]
      }
    wrapProgram $out/opt/brother/Printers/mfcj880dw/lpd/filtermfcj880dw \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          gnused
          file
          ghostscript
          a2ps
        ]
      }
  '';

  meta = with lib; {
    description = "Brother MFC-J880DW LPR driver";
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj880dw_us_eu_as&os=128";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; unfree;
    maintainers = with maintainers; [ _6543 ];
    platforms = with platforms; linux;
  };
}
