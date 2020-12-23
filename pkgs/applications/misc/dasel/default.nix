{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dasel";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xyh41vb2rypajjzbysw6k8x39bna8j3fmxcqyjcrqs0dzx78nk3";
  };

  vendorSha256 = "1il1vnv0v97qh8f47md5i6qaac2k8par0pd0z7zqg67vxq6gim85";

  buildFlagsArray = ''
    -ldflags=-s -w -X github.com/tomwright/dasel/internal.Version=${version}
  '';

  meta = with stdenv.lib; {
    description = "Query and update data structures from the command line";
    longDescription = ''
      Dasel (short for data-selector) allows you to query and modify data structures using selector strings.
      Comparable to jq / yq, but supports JSON, YAML, TOML and XML with zero runtime dependencies.
    '';
    homepage = "https://github.com/TomWright/dasel";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
