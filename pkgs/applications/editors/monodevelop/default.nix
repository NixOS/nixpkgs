{ stdenv, fetchurl, fetchgit
, autoconf, automake, pkgconfig, shared_mime_info, intltool
, glib, mono, gtk-sharp, gnome, gnome-sharp, unzip
}:

stdenv.mkDerivation rec {
  version = "5.9.0.431";
  revision = "7560726734fc7267de2fa9abed2509968deefaa8";
  name = "monodevelop-${version}";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/monodevelop/${name}.tar.bz2";
    sha256 = "1bgqvlfi6pilj2zxsviqilh63qq98wsijqdiqwpkqchcw741zlyn";
  };

  srcNugetBinary = fetchgit {
    url = "https://github.com/mono/nuget-binary.git";
    rev = "da1f2102f8172df6f7a1370a4998e3f88b91c047";
    sha256 = "1hbnckc4gvqkknf8gh1k7iwqb4vdzifdjd19i60fnczly5v8m1c3";
  };

  srcNUnit = fetchurl {
    url = "https://www.nuget.org/api/v2/package/NUnit/2.6.3";
    sha256 = "0bb16i4ggwz32wkxsh485wf014cqqzhbyx0b3wbpmqjw7p4canph";
  };

  srcNUnitRunners = fetchurl {
    url = "https://www.nuget.org/api/v2/package/NUnit.Runners/2.6.3";
    sha256 = "0qwx1i9lxkp9pijj2bsczzgsamz651hngkxraqjap1v4m7d09a3b";
  };

  srcNUnit2510 = fetchurl {
    url = "http://launchpad.net/nunitv2/2.5/2.5.10/+download/NUnit-2.5.10.11092.zip";
    sha256 = "0k5h5bz1p2v3d0w0hpkpbpvdkcszgp8sr9ik498r1bs72w5qlwnc";
  };

  srcNugetSystemWebMvcExtensions = fetchurl {
    url = https://www.nuget.org/api/v2/package/System.Web.Mvc.Extensions.Mvc.4/1.0.9;
    sha256 = "19wi662m8primpimzifv8k560m6ymm73z0mf1r8ixl0xqag1hx6j";
  };

  srcNugetMicrosoftAspNetMvc = fetchurl {
    url = https://www.nuget.org/api/v2/package/Microsoft.AspNet.Mvc/5.2.2;
    sha256 = "1jwfmz42kw2yb1g2hgp2h34fc4wx6s8z71da3mw5i4ivs25w9n2b";
  };

  srcNugetMicrosoftAspNetRazor = fetchurl {
    url = https://www.nuget.org/api/v2/package/Microsoft.AspNet.Razor/3.2.2;
    sha256 = "1db3apn4vzz1bx6q5fyv6nyx0drz095xgazqbw60qnhfs7z45axd";
  };

  srcNugetMicrosoftAspNetWebPages = fetchurl {
    url = https://www.nuget.org/api/v2/package/Microsoft.AspNet.WebPages/3.2.2;
    sha256 = "17fwb5yj165sql80i47zirjnm0gr4n8ypz408mz7p8a1n40r4i5l";
  };

  srcNugetMicrosoftWebInfrastructure = fetchurl {
    url = https://www.nuget.org/api/v2/package/Microsoft.Web.Infrastructure/1.0.0.0;
    sha256 = "1mxl9dri5729d0jl84gkpqifqf4xzb6aw1rzcfh6l0r24bix9afn";
  };

  postPatch = ''
    # From https://bugzilla.xamarin.com/show_bug.cgi?id=23696#c19

    # it seems parts of MonoDevelop 5.2+ need NUnit 2.6.4, which isn't included
    # (?), so download it and put it in the right place in the tree
    mkdir packages
    unzip ${srcNUnit} -d packages/NUnit.2.6.3
    unzip ${srcNUnitRunners} -d packages/NUnit.Runners.2.6.3

    # cecil needs NUnit 2.5.10 - this is also missing from the tar
    unzip -j ${srcNUnit2510} -d external/cecil/Test/libs/nunit-2.5.10 NUnit-2.5.10.11092/bin/net-2.0/framework/\*

    # the tar doesn't include the nuget binary, so grab it from github and copy it
    # into the right place
    cp -vfR ${srcNugetBinary}/* external/nuget-binary/

    # AspNet plugin requires these packages
    unzip ${srcNugetSystemWebMvcExtensions} -d packages/System.Web.Mvc.Extensions.Mvc.4.1.0.9
    unzip ${srcNugetMicrosoftAspNetMvc} -d packages/Microsoft.AspNet.Mvc.5.2.2
    unzip ${srcNugetMicrosoftAspNetRazor} -d packages/Microsoft.AspNet.Razor.3.2.2
    unzip ${srcNugetMicrosoftAspNetWebPages} -d packages/Microsoft.AspNet.WebPages.3.2.2
    unzip ${srcNugetMicrosoftWebInfrastructure} -d packages/Microsoft.Web.Infrastructure.1.0.0.0
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
