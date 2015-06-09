{ stdenv, fetchurl, fetchgit, fetchNuGet
, autoconf, automake, pkgconfig, shared_mime_info, intltool
, glib, mono, gtk-sharp, gnome, gnome-sharp, unzip
, dotnetPackages
}:

stdenv.mkDerivation rec {
  version = "5.9.0.431";
  revision = "7560726734fc7267de2fa9abed2509968deefaa8";
  name = "monodevelop-${version}";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/monodevelop/${name}.tar.bz2";
    sha256 = "1bgqvlfi6pilj2zxsviqilh63qq98wsijqdiqwpkqchcw741zlyn";
  };

  nunit2510 = fetchurl {
    url = "http://launchpad.net/nunitv2/2.5/2.5.10/+download/NUnit-2.5.10.11092.zip";
    sha256 = "0k5h5bz1p2v3d0w0hpkpbpvdkcszgp8sr9ik498r1bs72w5qlwnc";
  };

  postPatch = ''
    # From https://bugzilla.xamarin.com/show_bug.cgi?id=23696#c19

    # cecil needs NUnit 2.5.10 - this is also missing from the tar
    unzip -j ${nunit2510} -d external/cecil/Test/libs/nunit-2.5.10 NUnit-2.5.10.11092/bin/net-2.0/framework/\*

    # the tar doesn't include the nuget binary, so grab it from github and copy it
    # into the right place
    cp -vfR "$(dirname $(pkg-config NuGet.Core --variable=Libraries))"/* external/nuget-binary/
  '';

  # Revert this commit which broke the ability to use pkg-config to locate dlls
  patchFlags = [ "-p2" ];
  patches = [ ./git-revert-12d610fb3f6dce121df538e36f21d8c2eeb0a6e3.patch ];

  buildInputs = [
    autoconf automake pkgconfig shared_mime_info intltool
    mono gtk-sharp gnome-sharp unzip
    pkgconfig
    dotnetPackages.NUnit
    dotnetPackages.NUnitRunners
    dotnetPackages.Nuget
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

    # Without this, you get a missing DLL error any time you install an addin..
    ln -sv `pkg-config nunit.core --variable=Libraries` $out/lib/monodevelop/AddIns/NUnit
    ln -sv `pkg-config nunit.core.interfaces --variable=Libraries` $out/lib/monodevelop/AddIns/NUnit
    ln -sv `pkg-config nunit.framework --variable=Libraries` $out/lib/monodevelop/AddIns/NUnit
    ln -sv `pkg-config nunit.util --variable=Libraries` $out/lib/monodevelop/AddIns/NUnit
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ obadz ];
  };
}
