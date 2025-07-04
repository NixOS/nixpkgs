{
  abbrev = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rRtOqq7Uy3ItVoTWOUnkveHTTyqV4g25Ouz+fLrHQkI=";
      type = "gem";
    };
    version = "0.1.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  artifactory = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MCPVyWTDFnQJDWVaUW84ynVmXBUIQUDAi38oQRMa8mM=";
      type = "gem";
    };
    version = "3.0.17";
  };
  atomos = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fUOyLyRUo2us5VMtMHhbBt43ETmcsca/kyVz7aU2eJ8=";
      type = "gem";
    };
    version = "0.1.3";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fiw6Vcpw14YdXTyY5H2qRj7VOcNJyroitIMFuJGVctc=";
      type = "gem";
    };
    version = "1.3.2";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dAjEXQp/cxDQFsFqCEBbxNAVg+dd3Z4wR1rDog+IW4s=";
      type = "gem";
    };
    version = "1.1106.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xheq4/Q7or/p+BnBoxx8nb2j4dGjPHRsI8TcFWOIF6w=";
      type = "gem";
    };
    version = "3.224.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RNi1tpznOUzALzD5o1vqBOoSyUe1/+FHFTXupRGTaNc=";
      type = "gem";
    };
    version = "1.101.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3A7iq/CbKTz+Sc2hBLaX0uPdJCbsORlHriv6KoQWAM=";
      type = "gem";
    };
    version = "1.186.1";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UKh5aZGoYjJEQgNq16OVkgVyuEu2zSm5ReXhgA6Nods=";
      type = "gem";
    };
    version = "1.11.0";
  };
  babosa = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GN6kUPWVRi7Xy4BZWr12suU124yRs1D2xLPXOYbFvJk=";
      type = "gem";
    };
    version = "1.0.4";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  CFPropertyList = {
    dependencies = [
      "base64"
      "nkf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xFchYUrKjV62+iFvLsKOw43hqUUF6XZqIOmHRUksPEw=";
      type = "gem";
    };
    version = "3.0.7";
  };
  claide = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bTxcCJ3ekE2WqjDnMwbQ1L1ESxrMubMSXOFKPAGD+C4=";
      type = "gem";
    };
    version = "1.1.0";
  };
  colored = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nYK0esWJzn9sq2Sx8ZSiAJ6f0AwyalNXMh9Er6ssHSw=";
      type = "gem";
    };
    version = "1.2";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sTwr1+6uLPc1amJQHTmOcv3nh4C9Jq7GqXlXgpPCi0o=";
      type = "gem";
    };
    version = "3.1.2";
  };
  commander = {
    dependencies = [ "highline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fR3cP8yuYMyQa0ExuRYQfi7wEIhY9IX92jBhDA8pE9k=";
      type = "gem";
    };
    version = "4.6.0";
  };
  declarative = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gCHdbLF6srYSM8VpA9P1olnFz0PID/My1EfTlbF9n/k=";
      type = "gem";
    };
    version = "0.0.20";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZK3COiaiQQRMvmcyR3yhs8KB154iQLz/J1o3paDXjAc=";
      type = "gem";
    };
    version = "0.7.0";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X2k7IhVwhHZRdHm/KzgC5JBorYIWe80ihviZU2oX2TM=";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xZRHkzSa4DxDLheAosqSnWC4jH0U1S1jDbBQjDqKF9g=";
      type = "gem";
    };
    version = "2.8.1";
  };
  emoji_regex = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Ni+hWt2kUBsa/O7Ol5V1u1oP/q5i0qlMbuQ4d3MVks=";
      type = "gem";
    };
    version = "3.2.3";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2vmsOkwvyapIODoz2nfstE+jlREelzCE1cUvbyFK4PA=";
      type = "gem";
    };
    version = "0.112.0";
  };
  faraday = {
    dependencies = [
      "faraday-em_http"
      "faraday-em_synchrony"
      "faraday-excon"
      "faraday-httpclient"
      "faraday-multipart"
      "faraday-net_http"
      "faraday-net_http_persistent"
      "faraday-patron"
      "faraday-rack"
      "faraday-retry"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o4TFQc3miNaL+FBVcjrstBAMP6QbU76yARskWWCrLxk=";
      type = "gem";
    };
    version = "1.10.4";
  };
  faraday-cookie_jar = {
    dependencies = [
      "faraday"
      "http-cookie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-88u+by3j1AKPAKZ65BlrmTSKbcPAZf2ubTxxI/qLFAI=";
      type = "gem";
    };
    version = "0.0.7";
  };
  faraday-em_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ej1McHl4kSEFT1fgjNTvfkCtFUm2MQHzjHCTqdbFlok=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rg2tHDDMaS1ud9TDkcyttOykhUsxVjLNflYPdCdc+e0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sFXIQjdnNNf3Q1D+hhFUKuIADFOHNI2bqXCBCdbkCUA=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TI/x8Jc/+DW+jQQ+8WqvVPR/JbdXj22Rbe7oOZoE0zs=";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWsPHHMWpNbAUt0u71xC+IfVbZOhcf6IgNoa8GTKB1E=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-net_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y5ku/qQskloggYzzwIMJR5SFQf3PNFhCdVUQ0mbkxoI=";
      type = "gem";
    };
    version = "1.0.2";
  };
  faraday-net_http_persistent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cwy8jwPauUPD4cxY2Le+sULZ3waLOccYzYPjkmA0gzU=";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CzXs0C7PMjja8uebn7/Q9E0ttUm1fNCnHp2gN3Tj6c=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72DslporuVuNvyRAAVWu5koA/IumxqTTloVivMkjKMA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rdFU9POZJDy+BwgG7UG5aQaULn9SWbsf5try7I9JcZQ=";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Ft4yO6GTEeD+8J2+EUkPUp5GKZzAcBSZHusq+wFKek=";
      type = "gem";
    };
    version = "1.2.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X843XifTvbtGwY28prqa8p0zBIAa4euZV3HEeWxax+g=";
      type = "gem";
    };
    version = "2.4.0";
  };
  fastlane = {
    dependencies = [
      "CFPropertyList"
      "addressable"
      "artifactory"
      "aws-sdk-s3"
      "babosa"
      "colored"
      "commander"
      "dotenv"
      "emoji_regex"
      "excon"
      "faraday"
      "faraday-cookie_jar"
      "faraday_middleware"
      "fastimage"
      "fastlane-sirp"
      "gh_inspector"
      "google-apis-androidpublisher_v3"
      "google-apis-playcustomapp_v1"
      "google-cloud-env"
      "google-cloud-storage"
      "highline"
      "http-cookie"
      "json"
      "jwt"
      "mini_magick"
      "multipart-post"
      "naturally"
      "optparse"
      "plist"
      "rubyzip"
      "security"
      "simctl"
      "terminal-notifier"
      "terminal-table"
      "tty-screen"
      "tty-spinner"
      "word_wrap"
      "xcodeproj"
      "xcpretty"
      "xcpretty-travis-formatter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X4g7xqeRsiydtLloIxL6lkOqRa7vivu/UIzCf2vVibc=";
      type = "gem";
    };
    version = "2.227.2";
  };
  fastlane-sirp = {
    dependencies = [ "sysrandom" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZkePJbzQOewCzPZWJTc/yilkb6c9ZV61M8kV8QbF5kE=";
      type = "gem";
    };
    version = "1.0.0";
  };
  gh_inspector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BMynFxuHFk4FOqQxR5cdO39QD8tYF3aYiGtIqfxKGTk=";
      type = "gem";
    };
    version = "1.1.3";
  };
  google-apis-androidpublisher_v3 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iXCnKDnI36h9KQvfk1xkG/GMvUMjv3HRgq3ATAEI0hA=";
      type = "gem";
    };
    version = "0.54.0";
  };
  google-apis-core = {
    dependencies = [
      "addressable"
      "googleauth"
      "httpclient"
      "mini_mime"
      "representable"
      "retriable"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QyFwE7Ep19UsMev5QUZkbFX0Y+0l5orXUj+2RNWpzJc=";
      type = "gem";
    };
    version = "0.11.3";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mmUlz9bvHJo1X1k7/vEb0Psw4deF755cnaUcOBegUXs=";
      type = "gem";
    };
    version = "0.17.0";
  };
  google-apis-playcustomapp_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lZ5R+QRUtRrccuXDIrS0pXP4aVIMTXx8IO/R0mLkj9Y=";
      type = "gem";
    };
    version = "0.13.0";
  };
  google-apis-storage_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A+jMd14SQD5YeImd1L+5CVfnKB6JSTfwNkHDhXJi248=";
      type = "gem";
    };
    version = "0.31.0";
  };
  google-cloud-core = {
    dependencies = [
      "google-cloud-env"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5XLty/GJz8qxZZBiilFs7D9PY0VLcw5Z8LNldRICgc8=";
      type = "gem";
    };
    version = "1.8.0";
  };
  google-cloud-env = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YXmsuUaXWJLHkIdI31cipOut/Iz1u3sNjZM8pnGD+hU=";
      type = "gem";
    };
    version = "1.6.0";
  };
  google-cloud-errors = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tWvii4wQYoElIU3eVxuSXPzr28WGGeWYJQw3ohFPe0s=";
      type = "gem";
    };
    version = "1.5.0";
  };
  google-cloud-storage = {
    dependencies = [
      "addressable"
      "digest-crc"
      "google-apis-iamcredentials_v1"
      "google-apis-storage_v1"
      "google-cloud-core"
      "googleauth"
      "mini_mime"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUPQGpyDSVFJrM0tp3ss82XVtqrCG/P6Iead/I8e63Y=";
      type = "gem";
    };
    version = "1.47.0";
  };
  googleauth = {
    dependencies = [
      "faraday"
      "jwt"
      "multi_json"
      "os"
      "signet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gUra2qoSIdznKmcTHj7L1tI0kaFh7IT7Ff01O4fYyec=";
      type = "gem";
    };
    version = "1.8.1";
  };
  highline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ld1cEn1GknIUhvkXNzByNv4AU1LRKkIC4mxIYU9xlHk=";
      type = "gem";
    };
    version = "2.0.3";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sU/gRFzyS/muCYYz6bjULkwHw8H3AGcrCfv+Mv/UGqY=";
      type = "gem";
    };
    version = "1.0.8";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S2RZWOSUsvhsL4ovMEyVm6onOjEOd6KTHduYbYPkmMg=";
      type = "gem";
    };
    version = "2.9.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/I/jBcF8CcjOa8gl+aphvPIy2DVmmxBHLf+oYnlvIDs=";
      type = "gem";
    };
    version = "2.12.1";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5kJK4dgT9j52GgTWKE4Q5+xTHW9wGRf63NDZst6vHMU=";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  mini_magick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cdYljg6KPQSpoKCXhNXYV7QDoZilHdT4glEENeuV3dk=";
      type = "gem";
    };
    version = "4.13.2";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mHLQOo5VICDKCWra2/XjyxzRzdas08FhE2uKVzfNtKg=";
      type = "gem";
    };
    version = "2.4.1";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z8sErBa2nEgTd3Ai/c7aJOn3mOSAkqK4F+tMCngrB1E=";
      type = "gem";
    };
    version = "0.3.0";
  };
  nanaimo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+vBpVRurF/FRacH3ShxzwiBlfnG26QCRmJehDZkdByM=";
      type = "gem";
    };
    version = "0.4.0";
  };
  naturally = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qbiMfS+wbaPZxR9LiF81usk9dgF4N3gJox/PZ/q0oRM=";
      type = "gem";
    };
    version = "2.2.1";
  };
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+8FRvaAlRR9if6/fyz9PE9CyKuEfWMbTopOcdsX18SY=";
      type = "gem";
    };
    version = "0.2.0";
  };
  optparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JekEacHNRASKidwBwd3p1fC99xeFEFX7GCN3gHebBow=";
      type = "gem";
    };
    version = "0.6.0";
  };
  os = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V4FtajNOe9au0Ej0sDCCJsX7AnQztn2QqatDXzUQjT8=";
      type = "gem";
    };
    version = "1.1.4";
  };
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03pFJ8wRFgZDk99LQOHbvJTGX6nKLuxS7fmhNhZxikI=";
      type = "gem";
    };
    version = "3.7.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-v6fNUQgGb4yWAuDW1BFJmaXfWDmmMUnT6LD5wdNVg5Q=";
      type = "gem";
    };
    version = "6.0.2";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  representable = {
    dependencies = [
      "declarative"
      "trailblazer-option"
      "uber"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zCm/fuvDFlNYaEk3GkP/42xgtUsKY2W199lew00eus4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  retriable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ClpdDKS6YadvsxoXq49/gCgb6wQMMp0038E3oTmGiOA=";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DW3kgsdiQADZJpd3KrFOSNyjVin43fP0shyZGD/XDiA=";
      type = "gem";
    };
    version = "3.28.0";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  security = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Opd6Dsp3BugEyW2w3ZYZ4KlJaf46rJaA/Pwr+bioM7c=";
      type = "gem";
    };
    version = "0.1.5";
  };
  signet = {
    dependencies = [
      "addressable"
      "faraday"
      "jwt"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vGYOKmBiMRNIzTXsH/r94cXiIxIT4coST1eqT1nsR6M=";
      type = "gem";
    };
    version = "0.20.0";
  };
  simctl = {
    dependencies = [
      "CFPropertyList"
      "naturally"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uZB39NE62B6s6fhr9bpN8bC4k6TRs2i9PtWbWyf5I2s=";
      type = "gem";
    };
    version = "1.6.10";
  };
  sysrandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WsGsPC7GTvdqyRAYBZ9UG36PQ3+9oczdtPLFapzPHnU=";
      type = "gem";
    };
    version = "1.0.5";
  };
  terminal-notifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eg0rIhKrmDXAf0suIqlM/2QUnboe7SA8BINfeZEHjOo=";
      type = "gem";
    };
    version = "2.0.0";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+VG2r18+ACA/spCmaeCoXF3VsFGzsCM5LM/We6WrrpE=";
      type = "gem";
    };
    version = "3.0.2";
  };
  trailblazer-option = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IOTxLqTh9xjIAH55RMohoynu5O7Z4Ppd3m6K2KxDRKM=";
      type = "gem";
    };
    version = "0.1.2";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wJBlIRW+rnZDNsKIAtYz8gT7hNqTxqloql2OMZ6Bm1A=";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DgNvBHtP+2HyqkX1p3DsALTQQTBTFVipS/xbGStXBUI=";
      type = "gem";
    };
    version = "0.9.3";
  };
  uber = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W+60B/+Ae125lPgvqe4Hz86qVh2tivIL6IC8Z+upNdw=";
      type = "gem";
    };
    version = "0.1.0";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EieYdLum1eTScozvgUsZGX27ENeng3qGm6tl2pQ7f1o=";
      type = "gem";
    };
    version = "2.6.0";
  };
  word_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9VbUIkyBLjcQAPEqbugQLg2qckoxTD8kavqtdtgqzMc=";
      type = "gem";
    };
    version = "1.0.0";
  };
  xcodeproj = {
    dependencies = [
      "CFPropertyList"
      "atomos"
      "claide"
      "colored2"
      "nanaimo"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jMenO0UFwifeqwRNzhGO3nhwQccCvEdjaFai5Wb4VNM=";
      type = "gem";
    };
    version = "1.27.0";
  };
  xcpretty = {
    dependencies = [ "rouge" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sUxQ5yH2WJ7j1vU1Piws/NhUH6HqFtbGAoB91zJ/OJI=";
      type = "gem";
    };
    version = "0.4.1";
  };
  xcpretty-travis-formatter = {
    dependencies = [ "xcpretty" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qswzLxfLeyy6IimU4q3HQiPbiHJP52NBSDrTCY4jL5M=";
      type = "gem";
    };
    version = "1.0.1";
  };
}
