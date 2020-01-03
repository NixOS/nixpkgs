{ stdenv, lib, fetchurl, makeWrapper, jre_headless, libmatthew_java, dbus, dbus_java }:

stdenv.mkDerivation rec {
  pname = "signal-cli";
  version = "0.6.5";

  # Building from source would be preferred, but is much more involved.
  src = fetchurl {
    url = "https://github.com/AsamK/signal-cli/releases/download/v${version}/signal-cli-${version}.tar.gz";
    sha256 = "082kq8kadxbwzf31fmlq4in714id2irk0hhqsl53vsl3wmv45zvv";
  };

  buildInputs = lib.optional stdenv.isLinux [ libmatthew_java dbus dbus_java ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r lib $out/lib
    cp bin/signal-cli $out/bin/signal-cli
  '' + (if stdenv.isLinux then ''
    makeWrapper ${jre_headless}/bin/java $out/bin/signal-cli \
      --set JAVA_HOME "${jre_headless}" \
      --add-flags "-classpath '$out/lib/*:${libmatthew_java}/lib/jni'" \
      --add-flags "-Djava.library.path=${libmatthew_java}/lib/jni:${dbus_java}/share/java/dbus:$out/lib" \
      --add-flags "org.asamk.signal.Main"
  '' else ''
    wrapProgram $out/bin/signal-cli \
      --prefix PATH : ${lib.makeBinPath [ jre_headless ]} \
      --set JAVA_HOME ${jre_headless}
  '');

  # Execution in the macOS (10.13) sandbox fails with
  # dyld: Library not loaded: /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
  #   Referenced from: /nix/store/5ghc2l65p8jcjh0bsmhahd5m9k5p8kx0-zulu1.8.0_121-8.20.0.5/bin/java
  #   Reason: no suitable image found.  Did find:
  #         /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa: file system sandbox blocked stat()
  #         /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa: file system sandbox blocked stat()
  # /nix/store/in41dz8byyyz4c0w132l7mqi43liv4yr-stdenv-darwin/setup: line 1310:  2231 Abort trap: 6           signal-cli --version
  doInstallCheck = stdenv.isLinux;

  installCheckPhase = ''
    export PATH=$PATH:$out/bin
    # --help returns non-0 exit code even when working
    signal-cli --version
  '';

  meta = with lib; {
    homepage = https://github.com/AsamK/signal-cli;
    description = "Command-line and dbus interface for communicating with the Signal messaging service";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ivan erictapen ];
    platforms = platforms.all;
  };
}
