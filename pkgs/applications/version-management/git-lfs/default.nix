{ stdenv, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "git-lfs";
  version = "2.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "17x9q4g1acf51bxr9lfmd2ym7w740n4ghdi0ncmma77kwabw9d3x";
  };

  modSha256 = "1rjscc52rh8kxa64canw3baljllp1c639nsn89hs5b86c8v1jav7";

  patches = [
    (fetchpatch {
      # Build fails on v2.8.0 with go 1.13 due to invalid dependency version:
      #   go: github.com/git-lfs/go-ntlm@v0.0.0-20190307203151-c5056e7fa066: invalid pseudo-version: does not match version-control timestamp (2019-04-01T17:57:52Z)
      # TODO: Remove once https://github.com/git-lfs/git-lfs/commit/cd83f4224ce02398bdbf8b05830d92220d9b8e01 lands in a release.
      url = "https://github.com/git-lfs/git-lfs/commit/cd83f4224ce02398bdbf8b05830d92220d9b8e01.patch";
      sha256 = "17nmnlkknglqhzrky5caskbscrjp7kp9b5mfqznh1jx2hbxzlpbj";
    })
  ];

  subPackages = [ "." ];

  preBuild = ''
    go generate ./commands
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = https://git-lfs.github.com/;
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
