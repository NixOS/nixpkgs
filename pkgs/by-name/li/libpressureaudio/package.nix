{
  apulse,
  libpulseaudio,
  symlinkJoin,
}:

symlinkJoin {
  name = "libpressureaudio-${apulse.version}-nixpkgs";

  paths = [ apulse ];

  postBuild = ''
    pushd $out/lib
    mv apulse/* .
    rmdir apulse
    popd

    mkdir -p $out/include/
    pushd $out/include/
    tar xvf ${libpulseaudio.src} --wildcards "*/src/pulse/*.h" --strip-components 2
    popd

    mkdir -p $out/lib/pkgconfig
    pushd $out/lib/pkgconfig
    install -Dm644 ${./libpulse-mainloop-glib-template.pc} ./libpulse-mainloop-glib.pc
    version=${apulse.version} substituteAllInPlace ./libpulse-mainloop-glib.pc
    install -Dm644 ${./libpulse-simple-template.pc} ./libpulse-simple.pc
    version=${apulse.version} substituteAllInPlace ./libpulse-simple.pc
    install -Dm644 ${./libpulse-template.pc} ./libpulse.pc
    version=${apulse.version} substituteAllInPlace ./libpulse.pc
    popd
  '';

  meta = {
    homepage = "http://r-36.net/scm/pressureaudio/file/README.md.html";
    description = "libpulse without any sound daemons over pure ALSA";
    longDescription = ''
      apulse implements most of libpulse API over pure ALSA in 5% LOC of the
      original PulseAudio.

      However, apulse is meant to be used as a wrapper that updates the
      LD_LIBRARY_PATH environment environment variable, still requiring to link
      against the original libpulse.

      pressureaudio is a wrapper that joins apulse and pulseaudio headers plus
      custom pkgconfig files so that it replaces libpulse completely.

      In Nixpkgs, libpressureaudio is (re)implemented using Nixpkgs machinery.

      You can simply override libpulse with this and most packages would just
      work.
    '';
    inherit (apulse.meta) license maintainers platforms;
  };
}
