{ stdenv, fetchgit, fetchFromGitHub }:
let
  mkPlugin =
   { pname
   , version
   , passthru ? {}
   , installPhase ? ""
   , ... } @ attrs:
    stdenv.mkDerivation (attrs // {
      name = "redmine-plugin-${pname}-${version}";
      inherit pname;
      installPhase = ''
        mkdir $out
        cp -r $src $out/${pname}
        ${installPhase}
      '';
      passthru = passthru // {
        # NOTE: used as a filter when collecting propagatedPlugins.
        isRedminePlugin = true;
      };
    });
in rec {
  redmine_git_hosting = mkPlugin rec {
    pname = "redmine_git_hosting";
    version = "5d695c798c113e4de54b354632712b6876e4f362";

    src = fetchgit {
      # NOTE: fetchFromGitHub not working, zip/tar files are missing
      #owner  = "jbox-web";
      #repo   = "redmine_git_hosting";
      url    = "https://github.com/jbox-web/${pname}";
      rev    = version;
      sha256 = "1vps0rcig99m7r93bsvx5g89hrc4l39ymhm23g94j4kff91id7x0";
    };

    propagatedBuildInputs = [
      redmine_bootstrap_kit
    ];

    # NOTE: to configure this plugin you can install
    # a ${redmine.stateDir}/redmine_git_hosting_settings.yml
    # then run ${redmine.stateDir}/bundle exec rake redmine_git_hosting:update_settings
    installPhase = ''
      # Remove development code to avoid installing its dependencies.
      chmod -R +w $out/${pname}
      rm -rf $out/${pname}/spec
      rm -f  $out/${pname}/lib/tasks/ci_tools.rake
    '';

    meta = with stdenv.lib; {
      homepage = http://redmine-git-hosting.io/;
      description = "A Redmine plugin which makes configuring your own Git hosting easy ;)";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };

  redmine_bootstrap_kit = mkPlugin rec {
    pname = "redmine_bootstrap_kit";
    version = "c992de1a47df5be86377c49e069e7230652bd1e7";

    src = fetchgit {
      # NOTE: fetchFromGitHub not working, zip/tar files are missing
      #owner  = "jbox-web";
      #repo   = "redmine_bootstrap_kit";
      url    = "https://github.com/jbox-web/${pname}";
      rev    = version;
      sha256 = "04zvb1z53dv191g5yhlhflckyialgvwmsj95zix0j221yljbjvmr";
    };

    meta = with stdenv.lib; {
      homepage = https://jbox-web.github.io/redmine_bootstrap_kit/;
      description = "A Redmine plugin which makes developing your own Redmine plugin easy ;)";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };

  clipboard_image_paste = mkPlugin rec {
    pname = "clipboard_image_paste";
    version = "bcf0c2c8420cb6236a7a14e93fd21904abe49fa5";

    src = fetchgit {
      # NOTE: fetchFromGitHub not working, zip/tar files are missing
      #owner  = "peclik";
      #repo   = pname;
      url    = "https://github.com/peclik/${pname}";
      rev    = version;
      sha256 = "0zj2qj9zpd2w2mhbcifsqlldjfvbapp7kms3plfyg69h8rj0bb80";
    };

    meta = with stdenv.lib; {
      homepage = https://www.redmine.org/plugins/clipboard_image_paste;
      description = "Paste image from clipboard as an attachment.";
      license = licenses.gpl2;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };

  redmine_revision_branches = mkPlugin rec {
    pname = "redmine_revision_branches";
    version = "2424a61b8ad5d3cd0b08a42f0bc08023ef525e98";

    src = fetchgit {
      # NOTE: fetchFromGitHub not working, zip/tar files are missing
      #owner  = "tleish";
      #repo   = pname;
      url    = "https://github.com/tleish/${pname}";
      rev    = version;
      sha256 = "0xr8hh97parzja3xvdvia4wr5ah0r4yiq3ryxip3pvmvg39mh1j2";
    };

    meta = with stdenv.lib; {
      homepage = https://www.redmine.org/plugins/clipboard_image_paste;
      description = "Add branch information to the revision detail screen for a specific checkin";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };
}
