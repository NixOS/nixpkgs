{ stdenv, fetchurl, fetchgit
, autoconf, automake, pkgconfig, shared_mime_info, intltool
, glib, mono, gtk-sharp, gnome, gnome-sharp, unzip
}:

stdenv.mkDerivation rec {
  version = "5.7.0.660";
  revision = "6a74f9bdb90d9415b597064d815c9be38b401fee";
  name = "monodevelop-${version}";

  srcs = [
    (fetchurl {
      url = "http://download.mono-project.com/sources/monodevelop/${name}.tar.bz2";
      sha256 = "0i9fpjkcys991dhxh02zf9imar3aj6fldk9ymy09vmr10f4d7vbf";
    })
    (fetchurl {
      url = "https://launchpadlibrarian.net/153448659/NUnit-2.6.3.zip";
      sha256 = "0vzbziq44zy7fyyhb44mf9ypfi7gvs17rxpg8c9d9lvvdpkshhcp";
    })
    (fetchurl {
      url = "https://launchpadlibrarian.net/68057829/NUnit-2.5.10.11092.zip";
      sha256 = "0k5h5bz1p2v3d0w0hpkpbpvdkcszgp8sr9ik498r1bs72w5qlwnc";
    })
    (fetchgit {
      url = "https://github.com/mono/nuget-binary.git";
      rev = "ecb27dd49384d70b6c861d28763906f2b25b7c8";
      sha256 = "0dj0yglgwn07xw2crr66vl0vcgnr6m041pynyq0kdd0z8nlp92ki";
    })
  ];

  sourceRoot = "monodevelop-5.7";

  postPatch = ''
    # From https://bugzilla.xamarin.com/show_bug.cgi?id=23696#c19

    # it seems parts of MonoDevelop 5.2+ need NUnit 2.6.4, which isn't included
    # (?), so download it and put it in the right place in the tree
    mkdir -v -p packages/NUnit.2.6.3/lib
    cp -vfR ../NUnit-2.6.3/bin/framework/* packages/NUnit.2.6.3/lib
    mkdir -v -p packages/NUnit.Runners.2.6.3/tools/lib
    cp -vfR ../NUnit-2.6.3/bin/lib/* packages/NUnit.Runners.2.6.3/tools/lib

    # cecil needs NUnit 2.5.10 - this is also missing from the tar
    cp -vfR ../NUnit-2.5.10.11092/bin/net-2.0/framework/* external/cecil/Test/libs/nunit-2.5.10

    # the tar doesn't include the nuget binary, so grab it from github and copy it
    # into the right place
    cp -vfR ../nuget-binary-*/* external/nuget-binary/
    '';

  buildInputs = [
    autoconf automake pkgconfig shared_mime_info intltool
    mono gtk-sharp gnome-sharp unzip
  ];

  preConfigure = "patchShebangs ./configure";
  preBuild = ''
    cat > ./buildinfo <<EOF
    Release ID: ${version}
    Git revision: ${revision}
    Build date: 1970-01-01 00:00:01
    EOF
  '';

  postInstall = ''
    for prog in monodevelop mdtool; do
    patch -p 0 $out/bin/$prog <<EOF
    2a3,5
    > export MONO_GAC_PREFIX=${gnome-sharp}:${gtk-sharp}:\$MONO_GAC_PREFIX
    > export PATH=${mono}/bin:\$PATH
    > export LD_LIBRARY_PATH=${glib}/lib:${gnome.libgnomeui}/lib:${gnome.gnome_vfs}/lib:${gnome-sharp}/lib:${gtk-sharp}/lib:${gtk-sharp.gtk}/lib:\$LD_LIBRARY_PATH
    > 
    EOF
    done
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ obadz ];
  };
}
