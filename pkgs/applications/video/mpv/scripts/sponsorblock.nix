{ stdenv, fetchgit, python3 }:

stdenv.mkDerivation {
  pname = "sponsorblock-mpv-script";
  version = "2020-06-21";

  src = fetchgit {
    url = "https://github.com/po5/mpv_sponsorblock";
    rev = "2548e6c5f503f6d5ed38bb27923696abde601d6d";
    sha256 = "1iiqaka8wabham3aramiriviiisxyvd8raf7lhs84ni8wccccjj9";
  };

  dontBuild = true;

  buildInputs = [ python3 ];

  # The sponsorblock Python script tries to download the sponsor database into
  # '~/.local/share/sponsorblock' (set in postPatch), this patch makes it create
  # the directory before downloading.
  patches = [ ./sponsorblock.patch ];

  # Load python script from Nix store instead of the home directory.
  # Save database and user ID in "~/.local/share/sponsorblock".
  postPatch = ''
    substituteInPlace sponsorblock.lua \
      --replace 'scripts_dir, "sponsorblock_shared/sponsorblock.py"' \
        "\"$out/share/mpv/scripts\", \"sponsorblock_shared/sponsorblock.py\"" \
      --replace 'scripts_dir, "sponsorblock_shared/sponsorblock.txt"' \
        'os.getenv("HOME"), ".local/share/sponsorblock/sponsorblock.txt"' \
      --replace 'scripts_dir, "sponsorblock_shared/sponsorblock.db"' \
        'os.getenv("HOME"), ".local/share/sponsorblock/sponsorblock.db"'
  '';

  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp -r . $out/share/mpv/scripts
    rm -f $out/share/mpv/scripts/README.md
  '';

  # Needed by mpv wrapper
  passthru.scriptName = "sponsorblock.lua";

  meta = with stdenv.lib; {
    description = "A fully-featured port of SponsorBlock for mpv";
    homepage = "https://github.com/po5/mpv_sponsorblock";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
