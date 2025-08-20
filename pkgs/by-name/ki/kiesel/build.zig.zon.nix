# painfully hand-typed as zon2nix just fails with an opaque parseError and i
# don't have time to debug

{
  linkFarm,
  fetchgit,
  lib,
}:

linkFarm "zig-packages" [
  # for kiesel at large
  {
    name = "N-V-__8AABtBAABwSNNZpjUoWFLYSZZXjKgv9hKsDuZq64Zk";
    path = fetchgit {
      url = "https://github.com/ikskuh/any-pointer.git";
      rev = "0f9725a324d48239d1d7e07b7f270b0a87be576a";
      hash = "sha256-Qy7bFx3m02cBRe3jtsc11Vpm5WS6GY/ikdKy9EMFuo4=";
    };
  }
  {
    name = "args-0.0.0-CiLiqv_NAAC97fGpk9hS2K681jkiqPsWP6w3ucb_ctGH";
    path = fetchgit {
      url = "https://github.com/ikskuh/zig-args.git";
      rev = "9425b94c103a031777fdd272c555ce93a7dea581";
      hash = "sha256-hlt4URhSb6g8y9hrR1gJ6Jw8rVbLXW50/iITzL0Vxgc=";
    };
  }
  {
    name = "icu4zig-0.1.0-IT7GrJA8AgCIecMq7IDUl2UIPceXPcKmLaSeXnifOlfK";
    path = fetchgit {
      url = "https://codeberg.org/linusg/icu4zig.git";
      rev = "441e2f9a07b04908a1624c520d68ef0838e9bc30";
      hash = "sha256-GGxo3YRD8gU2RE7LgyCX4WoHGeN/+8slCc6oOH969dM=";
    };
  }
  {
    name = "kiesel_runtime-0.1.0-goZjAVAVAQDfuGJOxlhczZIskM3gU2y2mwUFL6T2VTOi";
    path = fetchgit {
      url = "https://codeberg.org/kiesel-js/runtime.git";
      rev = "ab0f87360f3bf7a4c18acf65ab06182364793a4c";
      hash = "sha256-f1XJrGQe9nA4Z3zVnKsB+807mEjeYGVMyKo8qpZog5s=";
    };
  }
  {
    name = "N-V-__8AAKjELQDJdyWac7qGYxGFWdUfBnuBrNMzVwY4OlTH";
    path = fetchgit {
      url = "https://github.com/bdwgc/bdwgc.git";
      rev = "edac9bb74d97137c3e6013745de87e6ee341cb5c";
      hash = "sha256-+izcpn0FQDjEMS6Xqoke8aBGIQgoc7nM61+1VhL+8AE=";
    };
  }
  {
    name = "parser_toolkit-0.1.0-baYGPXNCEwCoVvgTA29nOamiDp5yOC76lUaayy5Z2bYh";
    path = fetchgit {
      url = "https://github.com/ikskuh/parser-toolkit";
      rev = "c1a466b8df22cab7d665f44c645fb44f0aaf5077";
      hash = "sha256-z8rOC7H+VTGM3WSxjxhv/2n9zupWolPsKWrxcpj0+qQ=";
    };
  }
  {
    name = "stackinfo-0.1.0-NZ2qTp8bAAD6l36ZqllIVQvCh3EqEpseSt8ku_gI6IdJ";
    path = fetchgit {
      url = "https://codeberg.org/linusg/zig-stackinfo.git";
      rev = "b9e94aa7f6a778d704a2989df6267223446eb762";
      hash = "sha256-vRSQR1ldbvF643YopBDi1DksIK+J0p9gfzf+wzlmSoQ=";
    };
  }
  {
    name = "N-V-__8AAP7VNgAxNhXrraXkdJLiVGwAPSuCuL_oeoAiH1-9";
    path = fetchgit {
      url = "https://github.com/boa-dev/temporal.git";
      rev = "9f17b3c5be0e85c03e2ac656877cb8264c73c07a";
      hash = "sha256-e8zvtDLvqgO/ZT8LjQrWMOJppFvMcxkoHM/bCOThgs0=";
    };
  }
  {
    name = "unicode_id-0.0.1-MsAuU1OBAQDvOQJbtbcLiuTJfsoWQTnC7NCTCG4wBY26";
    path = fetchgit {
      url = "https://codeberg.org/injuly/unicode-id.git";
      rev = "ab463d6fe5dae906ac112c1361a7436bd1c9cda9";
      hash = "sha256-n/x3WEM9bamrmyPJsDjLoT3cqiCwDE6V311ZhI05Y/8=";
    };
  }
  {
    name = "N-V-__8AAK0TAgD4BBVEDr_a3ghcBGr44WChlcyNMPC-NUSY";
    path = fetchgit {
      url = "https://github.com/alimpfard/zigline.git";
      rev = "51f4b56bfd969a7b093a072f52562746ff215647";
      hash = "sha256-ogeyB4JD1qHw4pZYD6SZjUVLvHHvt7nL5Tv3GTj9gT4=";
    };
  }
  # for libregexp
  {
    name = "N-V-__8AAAPxOwAuis0t9b6eC_AHLuenZ2wND74IitOOIhKf";
    path = fetchgit {
      url = "https://github.com/quickjs-ng/quickjs.git";
      rev = "3d3b58d8815f0eef8122fad142a65f3bd21d273b";
      hash = "sha256-heUVwtimjTtOS4uXCoYOOFhlAZhly5nUDS05wXxc9ok=";
    };
  }
  # for zement
  {
    name = "build_crab-0.2.0-U0id_8nAAADK9_UWC9arjfPCPRP8uB22pKosub5c6cLB";
    path = fetchgit {
      url = "https://github.com/linusg/build.crab.git";
      rev = "93851de5631ee0397017253ea789a0a875525098";
      hash = "sha256-n7oyqDOsLnBuCQXi+y7tw1+63GIDBuoV//mEAn2qkMA=";
    };
  }
  # transitive deps
  {
    name = "N-V-__8AAFZjxgrKlvv6u2UnJdVrQu5_pK6bTPCfCfLQIFGo";
    path = fetchgit {
      url = "https://github.com/unicode-org/icu4x.git";
      rev = "472e602aeac54f1aa5a58e889cb93f075f565498";
      hash = "sha256-3RAizr1xjyzDL3JXSwIYlYyB/+HS+XvrNn418cQE8lI=";
    };
  }
]
