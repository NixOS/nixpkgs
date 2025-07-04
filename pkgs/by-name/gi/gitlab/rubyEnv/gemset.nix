src: {
  acme-client = {
    dependencies = [
      "base64"
      "faraday"
      "faraday-retry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4KBE+ZPNJvC6f4sTo7KwB++GTPqjMwdaLYhlsIcpdkE=";
      type = "gem";
    };
    version = "2.0.21";
  };
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dkY3tbLZe5TkEtViwXe/0WsP12nVXJiEY2L1Jj6Kqg0=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w8IFif5D5vqIu6LXam+YBf/dAlMfSppK+Bl9WfWlNgo=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "net-imap"
      "net-pop"
      "net-smtp"
      "rails-dom-testing"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-shPW2ICyOwk8z+87T4ej0n5GZkQvcbW2NLLRnhmkl1k=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8Jj2fQ/Fsw7M2D1llmrEfFAV3YC83HxqWjiZys41xg=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actiontext = {
    dependencies = [
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uOJhz61bxqeLPxW+Xnx/MhkAQbPcbwJ6OjU7Q5LS9+w=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jFWaITUBeY4ptQtTQaZDpwu/b6CqKrr1cdDvxZ3E9qo=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-djM3bIV/TEkdBrWn9dhtnwevxZU5g1Sj8avoDrfjV2c=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dHJ0ZoVKf73+jycCyjESsjh3UA1JJr9+AukhrVQhkfE=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9ArRYJvzO5ulvcThbYCnexUXFTI0zrQT0x1jXXuR8eM=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activerecord-explain-analyze = {
    dependencies = [
      "activerecord"
      "pg"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XeuxH+I/NbkZU6gGd9gLqShO5zf9nRSMHXYDzkUhf3s=";
      type = "gem";
    };
    version = "0.1.0";
  };
  activerecord-gitlab = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/activerecord-gitlab";
      type = "path";
    };
    version = "0.2.0";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rmuLB2hYxmbqrW+JbXhrZ2VCNehh4kqD9h8cyXtD/2M=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "mutex_m"
      "securerandom"
      "tzinfo"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nwxILkc7mGjLPf4+nbVJo70jAsAuT1laXKrBRKjHz7g=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "danger"
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  aes_key_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uTX0dWs3N1iV20VmnnnfzcD3kB4S1OCJdNVUDI4HdqU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  akismet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dJkbjj0yV+7qmWtHBpq7jaIAbIShRCVRI+jf/RyGsjA=";
      type = "gem";
    };
    version = "3.0.0";
  };
  aliyun-sdk = {
    dependencies = [
      "nokogiri"
      "rest-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZZFdP5tSgIIlPR+a0OTRPWtVKTP+SSUcaMaRXNTXW50=";
      type = "gem";
    };
    version = "0.8.0";
  };
  amatch = {
    dependencies = [
      "mize"
      "tins"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0/8VImouYnxygC6UV524KeXhDJbPidMpSUyuxYiRRfc=";
      type = "gem";
    };
    version = "0.4.1";
  };
  android_key_attestation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rn6wGpnSu0jvnPJMwTcSZp1wVsulpS0AlVT/A3VgVws=";
      type = "gem";
    };
    version = "0.3.0";
  };
  apollo_upload_server = {
    dependencies = [
      "actionpack"
      "graphql"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3OxAciWOZRiwuC4DtIXvvd3pRoE1Q8FBhPyBlS1rzbI=";
      type = "gem";
    };
    version = "2.1.6";
  };
  app_store_connect = {
    dependencies = [
      "activesupport"
      "jwt"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MPYkEJKY7QCaNkCO2sJkpSANln0o2WDz438C6cqyXOY=";
      type = "gem";
    };
    version = "0.38.0";
  };
  arr-pm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/f9IL3UjkjkgH01mfZNCRBJjmq0LOwrU2CfnxjfgrTk=";
      type = "gem";
    };
    version = "0.0.12";
  };
  asciidoctor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UiCIB/I336DKKYgvixPWC4IElhFq0ZHPGXylbyt/3fM=";
      type = "gem";
    };
    version = "2.0.23";
  };
  asciidoctor-include-ext = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QGrbnS+/wlU2YJyhO3h+1wTcBqTknWcJuD87rVePeHg=";
      type = "gem";
    };
    version = "0.4.0";
  };
  asciidoctor-kroki = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkIl2I8SDi57XT9d22fF5pSW1zRKFsV9tQNqyQASMGI=";
      type = "gem";
    };
    version = "0.10.0";
  };
  asciidoctor-plantuml = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QH5HzRGG3tXMx18MgS5VJMJsVx1UIkfFEyq7j0e9F5M=";
      type = "gem";
    };
    version = "0.0.16";
  };
  ast = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HigCMuajN1TN5UK8XvhVILdNsqrHPsFKzvRTeERHzBI=";
      type = "gem";
    };
    version = "2.4.2";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "metrics"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WJ0RrG1YCNoZXtWscfN6/KtQWFWqlYv1/EY6VGnDQ3c=";
      type = "gem";
    };
    version = "2.24.0";
  };
  atlassian-jwt = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L9LYdBh3Py4UDAOMsi4EkGlwiv8r0KQjp+F0BXTpeCM=";
      type = "gem";
    };
    version = "0.2.1";
  };
  attr_encrypted = {
    dependencies = [ "encryptor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-flyAFZ5uOO1A3E4uZcT1cjT+Hzdr3cQMi3c7+5uBrVE=";
      type = "gem";
    };
    version = "4.2.0";
  };
  attr_required = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8Ov8VrNeh09NCueZBm28H4Hv7+I2TKOAPcnqak3my5k=";
      type = "gem";
    };
    version = "1.0.2";
  };
  awesome_print = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6ZsytwSs/xbXaLNGhoB5PO1Av9xFN+sH4GpL4REzeG4=";
      type = "gem";
    };
    version = "1.9.2";
  };
  awrence = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3R0hTBKpH0SdHvgdfuO6vCgWlE5FB1LnUixlUhhySD4=";
      type = "gem";
    };
    version = "1.2.1";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8UNMwDqyJIdW6wLPpF6QDlmgYdf73Eqf2Cpd0j15bT8=";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KXnzMX06dXUI010PMig59CLLyEWVibfMSjiJ0Ahagwc=";
      type = "gem";
    };
    version = "1.1001.0";
  };
  aws-sdk-cloudformation = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t2r/H6TOgl37IdiLEFveUDexL1WWzpvnh3jS8DXoc64=";
      type = "gem";
    };
    version = "1.131.0";
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
      hash = "sha256-fErYi0iYNasXs0KmIeggyldZ6rBLaKMiE9ALlZRSTs0=";
      type = "gem";
    };
    version = "3.225.0";
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
      hash = "sha256-5/dQE8upujVxRPZrvGAGMcGS4s2p3VcnlL4jllTiz0k=";
      type = "gem";
    };
    version = "1.76.0";
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
      hash = "sha256-KmIvptcv/v0+Yj2wBlD8nXsXegCGJqSf3ithJbWmfnQ=";
      type = "gem";
    };
    version = "1.189.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-d1PjIMOfgPgvngiDsw3g57medWrbrtyAxQtq1Z1Jw3k=";
      type = "gem";
    };
    version = "1.9.1";
  };
  axe-core-api = {
    dependencies = [
      "dumb_delegator"
      "ostruct"
      "virtus"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bhDz7RwDGATxboFU2dXcZYVk0QhQzuhg4SX+Zlw/AUg=";
      type = "gem";
    };
    version = "4.10.3";
  };
  axe-core-rspec = {
    dependencies = [
      "axe-core-api"
      "dumb_delegator"
      "ostruct"
      "virtus"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yiHQER4tD80PHakiyQcTNzNnMqpqOo3CG+2UyacBUn4=";
      type = "gem";
    };
    version = "4.10.3";
  };
  axiom-types = {
    dependencies = [
      "descendants_tracker"
      "ice_nine"
      "thread_safe"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wf8RPz3lFvoZWy234KmpX9GwhHWlAv9mDQRQegmYA4M=";
      type = "gem";
    };
    version = "0.1.1";
  };
  babosa = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-piGNuKTcj9mSYN3ovD1foaDFIXgZbiNuuzHkH73NuKY=";
      type = "gem";
    };
    version = "2.0.0";
  };
  backport = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kSx9/dnuRiXQE938y2IFw/ktppqJkPZcRA5A9bL8f3U=";
      type = "gem";
    };
    version = "1.2.0";
  };
  base32 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y5gQq3x5hi7W6tJUs6RPolNdCIOWzUEu7zi9wgYFWro=";
      type = "gem";
    };
    version = "0.3.4";
  };
  base64 = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  batch-loader = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lkv2OLj0mLq0CrqvxvicBXsuAqoltk/B7BKHKta/8hM=";
      type = "gem";
    };
    version = "2.0.5";
  };
  bcrypt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hBD4x7PtVKPADNJFa/E5F9aVEX8DMhjiSDsuQLB4QJk=";
      type = "gem";
    };
    version = "3.1.20";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  benchmark-ips = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tyvIpl1SXVkG+M2UJw3M9zRS7jJXoyuJ+9ZoTT6Kmx0=";
      type = "gem";
    };
    version = "2.14.0";
  };
  benchmark-malloc = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N8aPBDUmFjQCb1hNeZVqNTJaMCfj5rTMjXV1qhBTfms=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark-memory = {
    dependencies = [ "memory_profiler" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yh5DZDOwlTXuj2T4BgCl7bQHz/H2rHDgicojgRjmq1w=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark-perf = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/isBlZ894PndNIINVO+IHrTzWJ/Mt9F7YwaKyS1/liE=";
      type = "gem";
    };
    version = "0.6.0";
  };
  benchmark-trend = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3loCqfRDur77vZd4R1mCDezuhVSgwnPYWcAqCZCEXYE=";
      type = "gem";
    };
    version = "0.4.0";
  };
  better_errors = {
    dependencies = [
      "erubi"
      "rack"
      "rouge"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-95jxusk/PndZJbf8skz/vPC7Yu4iEPU1DxYaa3X8CnM=";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-55mzaaAAX8bWLu1+8ZE5rJvDGcxRRwxje53N9ZNgATM=";
      type = "gem";
    };
    version = "3.1.7";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w44Mmf/NgMEKCnrmyFhtL+Jr8kXL76yQvsh2RSMiD2o=";
      type = "gem";
    };
    version = "2.4.11";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oq0l0dU4/G55cpePm/USzNmSeEAJlHyBYzvqd2cTFh0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CuI5PB6RHji+DyTpFz575XDDZQEoJRvwYkAEb4SgfQA=";
      type = "gem";
    };
    version = "1.18.6";
  };
  browser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YnRTAXAf8sbF0y0He7ElMrIL4mGSnctSxnge0NVlizw=";
      type = "gem";
    };
    version = "5.3.1";
  };
  builder = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mcrwivYMjX86awBAKcTDwL2uvO1slJFl/pjx2yf7vBA=";
      type = "gem";
    };
    version = "3.2.4";
  };
  bullet = {
    dependencies = [
      "activesupport"
      "uniform_notifier"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tLmQXra4A9mgumIJRO15yLsn/zypDvj445/yHbW3xUI=";
      type = "gem";
    };
    version = "8.0.8";
  };
  bundler-checksum = {
    dependencies = [ ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/bundler-checksum";
      type = "path";
    };
    version = "0.1.0";
  };
  byebug = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KFQ0pHMpAtm7JyjH3VOk/7YqiZqFzNfcbsK+n/KGh4=";
      type = "gem";
    };
    version = "12.0.0";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtunIFeOocpl/XpB0WPdNoUCwZGARVj24PcbORBUru8=";
      type = "gem";
    };
    version = "3.40.0";
  };
  capybara-screenshot = {
    dependencies = [
      "capybara"
      "launchy"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gWuTcKB3Ugl8gqBfVoqvXTt/RcPbXTqrIBQHHhs8DHc=";
      type = "gem";
    };
    version = "1.0.26";
  };
  carrierwave = {
    dependencies = [
      "activemodel"
      "activesupport"
      "mime-types"
      "ssrf_filter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gXctq9GDDtvX9FJtKuLHn5dPHUiQDD8D9+y3xldGOiE=";
      type = "gem";
    };
    version = "1.3.4";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nuCX/FjZvF5AbREs0tThEsc1TsFvi2/zTkcyweRLTrc=";
      type = "gem";
    };
    version = "0.5.9.8";
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
  character_set = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K3MXRira7f8L0Vdq6G1xvF7+EzpdC3wlcCGwD+MVP1E=";
      type = "gem";
    };
    version = "1.8.0";
  };
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tJ6KEc4ZIeLFtlURu4ZK5RcgzpvRwzbM8OiebIrmLbA=";
      type = "gem";
    };
    version = "0.7.9";
  };
  chef-config = {
    dependencies = [
      "addressable"
      "chef-utils"
      "fuzzyurl"
      "mixlib-config"
      "mixlib-shellout"
      "tomlrb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wYOi/0HajWOx5KYIU8nHAaBTq5r+E992eleNtfBwct8=";
      type = "gem";
    };
    version = "18.3.0";
  };
  chef-utils = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gn96rOJrqfX4rKRQWWRCBcxxW63tgCKfH9VRjSGXBwE=";
      type = "gem";
    };
    version = "18.3.0";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-idWzG1XAz02jz4mitOvDF42Kvoy68Rah26lWaFAv3P4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  circuitbox = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SW6cHnZJbh4UFJAIX2zcxKje3HLag2G+9p2MVCO02hQ=";
      type = "gem";
    };
    version = "2.0.0";
  };
  citrus = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TsJBL8OJrRhnNfS67hRg95AKjhMP/j8hazDU+caE9lA=";
      type = "gem";
    };
    version = "3.0.2";
  };
  claide = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bTxcCJ3ekE2WqjDnMwbQ1L1ESxrMubMSXOFKPAGD+C4=";
      type = "gem";
    };
    version = "1.1.0";
  };
  claide-plugins = {
    dependencies = [
      "cork"
      "nap"
      "open4"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x+p4vAZ6sjvOhRVJfNzcuPAchtrfvhPERkTjgpIsHC4=";
      type = "gem";
    };
    version = "0.9.2";
  };
  click_house-client = {
    dependencies = [
      "activesupport"
      "addressable"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/click_house-client";
      type = "path";
    };
    version = "0.1.0";
  };
  cloud_profiler_agent = {
    dependencies = [
      "google-cloud-profiler-v2"
      "google-protobuf"
      "googleauth"
      "stackprof"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/cloud_profiler_agent";
      type = "path";
    };
    version = "0.0.1.pre";
  };
  coderay = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  coercible = {
    dependencies = [ "descendants_tracker" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UIGtJDUsyENc5UcrwvqjAmDH6n8hAsxqnxZ8TZv/qtw=";
      type = "gem";
    };
    version = "1.0.0";
  };
  colored2 = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sTwr1+6uLPc1amJQHTmOcv3nh4C9Jq7GqXlXgpPCi0o=";
      type = "gem";
    };
    version = "3.1.2";
  };
  commonmarker = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nR0101h0AVG84pI1rr/sxjMU+1fdiag+ctQGG0/j0r8=";
      type = "gem";
    };
    version = "0.23.11";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gv3T+KCBbijVE+Y3uyuQpF17mCvfTzoFEXItLklYAeI=";
      type = "gem";
    };
    version = "1.2.3";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z9dKgrmwlNHOMMTxo0baI+4Z3IoGKhaoX1jqsc7UMFs=";
      type = "gem";
    };
    version = "2.5.3";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r9m3WhsEcFndoi3w48CjhulvUPZ1LIfEsAsan8vnfNY=";
      type = "gem";
    };
    version = "1.29.2";
  };
  cork = {
    dependencies = [ "colored2" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKCsUOJi+FFNGr4KFOleccmLJOM3hpDl0ETa8AE61Lw=";
      type = "gem";
    };
    version = "0.3.0";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YyR8ZqW8duU5JnVldP43JMwKiHB+NYyQUyrioyDphgE=";
      type = "gem";
    };
    version = "1.3.0";
  };
  countries = {
    dependencies = [
      "i18n_data"
      "sixarm_ruby_unaccent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0y6KPAsilJ8aQeptkAX1Fo/84ib4/gd9HWvnhf/6gcU=";
      type = "gem";
    };
    version = "4.0.1";
  };
  coverband = {
    dependencies = [
      "base64"
      "redis"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RRc76bAPcMFwDVoNW94dVTKIhidB3FxgLFjTs/sPgiU=";
      type = "gem";
    };
    version = "6.1.5";
  };
  crack = {
    dependencies = [ "safe_yaml" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Uxi6jNnPfgtf6ziUgEhQO6Sx/cG2/zCjnwoA/rYDayk=";
      type = "gem";
    };
    version = "0.4.3";
  };
  crass = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FFgIqVuezsVYJmryBttKwjqHtEmdqx6VldhfwEr1F0=";
      type = "gem";
    };
    version = "1.0.6";
  };
  creole = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lRcB4tgHYPFWscsqk0ccqXwHYom+zAZ6M7dFEz7TLAM=";
      type = "gem";
    };
    version = "0.5.0";
  };
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8s5hSM1QUpewe9vnpdtMzlz1MAcfm3MrmiNTjWzcARM=";
      type = "gem";
    };
    version = "1.14.0";
  };
  cssbundling-rails = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U67NWn0krJyPzZKXWs0Ogw/q1O5Fg9PT1Ju2RlGUbkE=";
      type = "gem";
    };
    version = "1.4.3";
  };
  csv = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C70d79wxE0q+/tAnpjmzcjwnU4YhUPTD7mHKtxsg1n0=";
      type = "gem";
    };
    version = "3.3.0";
  };
  csv_builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/csv_builder";
      type = "path";
    };
    version = "0.1.0";
  };
  cvss-suite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VBmfweDV2DOxyxYUU0ORQ2ZcZEzTvi0hwu7lf6Bu2EM=";
      type = "gem";
    };
    version = "3.3.0";
  };
  danger = {
    dependencies = [
      "claide"
      "claide-plugins"
      "colored2"
      "cork"
      "faraday"
      "faraday-http-cache"
      "git"
      "kramdown"
      "kramdown-parser-gfm"
      "no_proxy_fix"
      "octokit"
      "terminal-table"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q+VSxnMQMCNaMP3q/nA9Liq5wwkXFUSJyw7NmtMlnYA=";
      type = "gem";
    };
    version = "9.4.2";
  };
  danger-gitlab = {
    dependencies = [
      "danger"
      "gitlab"
    ];
    groups = [
      "danger"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SX3X0PZRORPeZRAZIj2AWM9JTfEKy9F96SsXXfoEo6g=";
      type = "gem";
    };
    version = "8.0.0";
  };
  database_cleaner-active_record = {
    dependencies = [
      "activerecord"
      "database_cleaner-core"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MijW2OwfIQP9arRo2ukjQkMYvPq89d1bAuX8sMSG4cc=";
      type = "gem";
    };
    version = "2.2.0";
  };
  database_cleaner-core = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hkZXTDIWLlnte1JYqXogjTxEVRuFTlEJlPJGg4ZdhGw=";
      type = "gem";
    };
    version = "2.0.1";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  deb_version = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wh+RHX8v0dYSGcquJU/AeOZZjkd/3/igWhi+xscu5xM=";
      type = "gem";
    };
    version = "1.0.2";
  };
  debug_inspector = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6qWi0BleHWX7QWTo5+RmzKLn61O8XmCM8SuL8Cw6hgY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  deckar01-task_list = {
    dependencies = [ "html-pipeline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZqvcfgCep1lzK7U4Z+HqQt5VDiqgOsMKAVy/QqBMFmc=";
      type = "gem";
    };
    version = "2.3.4";
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
  declarative_policy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mvTPKZreA/K79jkI8s5qEX0TL8cUw5oShZZmf7EzMcs=";
      type = "gem";
    };
    version = "1.1.0";
  };
  deprecation_toolkit = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iyHRFoSkeSuOHQn6pHSJcPv0zsk/bw7EflfotxUoEk0=";
      type = "gem";
    };
    version = "2.2.3";
  };
  derailed_benchmarks = {
    dependencies = [
      "base64"
      "benchmark-ips"
      "bigdecimal"
      "drb"
      "get_process_mem"
      "heapy"
      "logger"
      "memory_profiler"
      "mini_histogram"
      "mutex_m"
      "ostruct"
      "rack"
      "rack-test"
      "rake"
      "ruby-statistics"
      "ruby2_keywords"
      "thor"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZUKAZk/e1Byc2Pwn/A/PrwlgI6+rkOtKwRhbpwxdRDk=";
      type = "gem";
    };
    version = "2.2.1";
  };
  descendants_tracker = {
    dependencies = [ "thread_safe" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6cQd1M+7hYKakwHqfnxIwqA7JvCTGdsjDmR5zNx4CJc=";
      type = "gem";
    };
    version = "0.0.4";
  };
  devfile = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-erlUz7I3VbupTRiOWSf6Zr6XkIS4TBz0ZMQT+FAekrU=";
      type = "gem";
    };
    version = "0.4.4";
  };
  device_detector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xf4/5CyrLoqgHxk7IHS4uxUQNzzkcScgbyjH3qdanHk=";
      type = "gem";
    };
    version = "1.1.3";
  };
  devise = {
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "warden"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kgBC/l5wTFSKpOtl691lmAuD/65n/rMsaXIGv9l1p/g=";
      type = "gem";
    };
    version = "4.9.4";
  };
  devise-pbkdf2-encryptable = {
    dependencies = [
      "devise"
      "devise-two-factor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/devise-pbkdf2-encryptable";
      type = "path";
    };
    version = "0.0.0";
  };
  devise-two-factor = {
    dependencies = [
      "activesupport"
      "attr_encrypted"
      "devise"
      "railties"
      "rotp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yV9bB1M+YiF6rtPDhodNlOLUcvtfK2WYr+hgD8F6i5U=";
      type = "gem";
    };
    version = "4.1.1";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sbk0AByMau2ze6GdrsXGNNonsxino8ZUrpeda6GSm2c=";
      type = "gem";
    };
    version = "1.5.0";
  };
  diff_match_patch = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/diff_match_patch";
      type = "path";
    };
    version = "0.1.0";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eThKtcqC0OEVsncfCWHifBZMRWB0vS7Ea2N+v3tuR+M=";
      type = "gem";
    };
    version = "3.4.4";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XKRW8zUtxf8X65Xes91aedx5+L91HYAFq8pbe5slISQ=";
      type = "gem";
    };
    version = "0.6.5";
  };
  docile = {
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xxc0veI3ISRcIMPXI+dsEEII4aoBJ3ppkBzncPDruNM=";
      type = "gem";
    };
    version = "1.4.0";
  };
  domain_name = {
    dependencies = [ "unf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AApgBFTLSjRHabLxC1MXZep706ME/kftEuXKHquWmFE=";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  doorkeeper = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pz0Hrq9ZCx5+KjU5BEbyMTHJ83vAVhZT5RTTlz9NUNM=";
      type = "gem";
    };
    version = "5.8.2";
  };
  doorkeeper-device_authorization_grant = {
    dependencies = [ "doorkeeper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lMOsEqDVCUKFDs1Y7WQpizl6XpA+iIDLaNQIVgCTJnk=";
      type = "gem";
    };
    version = "1.0.3";
  };
  doorkeeper-openid_connect = {
    dependencies = [
      "doorkeeper"
      "jwt"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UqmpwDF29fpU0EuPU3iQK+/xJuNCP6RHKIsWgna39tM=";
      type = "gem";
    };
    version = "1.8.11";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JFHtXo5Dd216eH5R1viQO5jkRhRsetFD1WeMwsQJ1Uc=";
      type = "gem";
    };
    version = "2.7.6";
  };
  drb = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  dry-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KOrRafhylU3QiRDrjq1Zz4bNGLSqsyHo7u/pRXSVafA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8y9CReD1Tnh/NwhYTtj3VFqvjdmQcuNvFpMSRo7FRQ0=";
      type = "gem";
    };
    version = "1.0.1";
  };
  dry-inflector = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-atIjYcotbz8AGuMDf/z+oBFj9kQoDROpGV08OpTdFiY=";
      type = "gem";
    };
    version = "1.0.0";
  };
  dry-logic = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-me0hgPGXDD2CRwBPJ3oB3/vo6Cz2aA3pxyCTEths1BY=";
      type = "gem";
    };
    version = "1.5.0";
  };
  dry-types = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "dry-inflector"
      "dry-logic"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EhZYQRRaGN0iFR8UNwe5DICT9x5a4G7g8jAfUyH4zbg=";
      type = "gem";
    };
    version = "1.7.1";
  };
  dumb_delegator = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/15BGBbS2K2OJgsmnnEq44Od3bD5+OGNOxo/4I9tLpQ=";
      type = "gem";
    };
    version = "1.0.0";
  };
  duo_api = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Bqa0BhhObksUr3OJrDmQ5mf7hQmh/rp9468veNmMCHc=";
      type = "gem";
    };
    version = "1.4.0";
  };
  ed25519 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ful/UZhomhVCRxafNFPvTP0/ekdIH94K4zIGzf3KxQY=";
      type = "gem";
    };
    version = "1.4.0";
  };
  elasticsearch = {
    dependencies = [
      "elasticsearch-api"
      "elasticsearch-transport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7QgPCF2TnyHQf0JOvOqVMm5L2193Co8zqsaZN08v/IY=";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-api = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/tj3tkSTyXzzmEozOWp5ggS1S44bAcW2wJn6P9QgkQc=";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-model = {
    dependencies = [
      "activesupport"
      "elasticsearch"
      "hashie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i1xLV2ZLsp9IVPo5YDtczs+/myL+6HvNFpFzIdrmogs=";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-rails = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-B1DcDpVjWNmjoJEqgYbCZu8Z+N4LF4xhmW7RppmBVuQ=";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-transport = {
    dependencies = [
      "base64"
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0YBX1SleTDn+gAhO3p4A6cDg10WANImF+Gd7L7f3DwM=";
      type = "gem";
    };
    version = "7.17.11";
  };
  email_reply_trimmer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-n+3iIs5mCZPk4uPa0oJTXOt5FOJG64MCwZqp4CH3Mm4=";
      type = "gem";
    };
    version = "0.1.6";
  };
  email_spec = {
    dependencies = [
      "htmlentities"
      "launchy"
      "mail"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3yO+ehMRhvej1b47NeqskZb5rBO9JsnD1ZNB4T2FLRE=";
      type = "gem";
    };
    version = "2.3.0";
  };
  email_validator = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WrI4CVvseu+TifIw6eDGTFCBzfkfGdbFzs7gqTryBgQ=";
      type = "gem";
    };
    version = "2.2.4";
  };
  encryptor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q/I/lKtNhkuM6oW0PzQyBEpgABmCzafDPBzZDajbGWk=";
      type = "gem";
    };
    version = "3.0.0";
  };
  error_tracking_open_api = {
    dependencies = [ "typhoeus" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/error_tracking_open_api";
      type = "path";
    };
    version = "1.0.0";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-J77bdN+x4E/2BnSXXhgtjKeH8iJPLoFDJox2lvQuRyM=";
      type = "gem";
    };
    version = "1.12.0";
  };
  escape_utils = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3/twEJIogKzmzu1kIVbGTipkYg8n4ISfQ7xPaP08LAk=";
      type = "gem";
    };
    version = "1.3.0";
  };
  et-orbi = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0m6GjMIduIKAqewaUKo9pdJn65sgN7p7gx1sJzH132Q=";
      type = "gem";
    };
    version = "1.2.11";
  };
  ethon = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u6DaHOqKw+H1zdfLHLX8eNesViwzc28Y8MPrK2MFPZ4=";
      type = "gem";
    };
    version = "0.16.0";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CfDeWRtb0cZCaAqhNAU4oWuQwREWlLRvYfbYv900Akk=";
      type = "gem";
    };
    version = "0.99.0";
  };
  execjs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bZOZGc/YG8xNZVbzIsOZWnDP5CieoL07H5mbSJwyMIg=";
      type = "gem";
    };
    version = "2.8.1";
  };
  expgen = {
    dependencies = [ "parslet" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TmoPZbIQogHWBF3rs+YqJOMyUaSfgaEbBn0wOmDTojk=";
      type = "gem";
    };
    version = "0.1.1";
  };
  expression_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K1bbPP/EjDM39PKfW8I3TIbnuimstAJpx0u1Wvn4aKQ=";
      type = "gem";
    };
    version = "0.9.0";
  };
  extended-markdown-filter = {
    dependencies = [ "html-pipeline" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yO7vdAn7rhjGtAfNPk7rXSXDXLCP4awG83XfPbLU8Tg=";
      type = "gem";
    };
    version = "0.7.0";
  };
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y3Szo1k7gHfumFbVU9LoTXW0e5Eswk6v6kBi+TY9ImE=";
      type = "gem";
    };
    version = "6.5.0";
  };
  factory_bot_rails = {
    dependencies = [
      "factory_bot"
      "railties"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E54XyqLFDwmP3fXl4fKegGc1ICTpHKEYbQGLNlieXIg=";
      type = "gem";
    };
    version = "6.4.4";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFMetUZ+fXTUUXYw+pbxpwA2R8vyCpo+Bn0JiUEhe3U=";
      type = "gem";
    };
    version = "2.13.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2S2XVjXix/5SXdSU/NS5u38KSg7A1fTBXHKVMP24B/k=";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday-http-cache = {
    dependencies = [ "faraday" ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZLc2bWblCOHD3YVeuyDOnaQpMw5BKiPZ67wKensidGM=";
      type = "gem";
    };
    version = "2.5.0";
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
    dependencies = [ "net-http" ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Fie+QUlg0BMWkRkP9SRQa6ZgdAKlD7bszanmTKYPhZ8=";
      type = "gem";
    };
    version = "3.1.0";
  };
  faraday-net_http_persistent = {
    dependencies = [
      "faraday"
      "net-http-persistent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tBcgsT9W2udxFNneVLrvLXbQsGq0DWlbKpjiVLVq3gs=";
      type = "gem";
    };
    version = "2.1.0";
  };
  faraday-retry = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QUb+0UVJwFgL8UWR/KQZpAcX3g3STyZ6jsLZpyhndgg=";
      type = "gem";
    };
    version = "2.2.1";
  };
  faraday-typhoeus = {
    dependencies = [
      "faraday"
      "typhoeus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JMYUfCE4GN3j68UK5Hq5L5p+VUkDqjYnBxJvdJxokOc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday_middleware-aws-sigv4 = {
    dependencies = [
      "aws-sigv4"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oAHqT2h8ocYLrY8qYnGWkFzj2/KF5GHcFTJA6S6qvo8=";
      type = "gem";
    };
    version = "1.0.1";
  };
  fast_blank = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jp/DBBT+1OZAO8SkkIHh6lOfi5Im5ZJ27R7676uqF+o=";
      type = "gem";
    };
    version = "1.0.1";
  };
  fast_gettext = {
    dependencies = [
      "prime"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jmthJnbWASCWYtLNeT7UoGf4NMjKZe3nk7rMm8wcJ2M=";
      type = "gem";
    };
    version = "4.1.0";
  };
  ffaker = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q+P4wS1gL7xwOYvovRrIQaAx6r3BKvAVB+dqjWdaXVI=";
      type = "gem";
    };
    version = "2.24.0";
  };
  ffi = {
    groups = [
      "default"
      "development"
      "kerberos"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KXI1hC5ZR8wwNuvmQHdYS/9YPNek6U6aAv3sOZ70baY=";
      type = "gem";
    };
    version = "1.17.2";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AZ84mweKL+yd5/T2V3EJX4CkR+NENrRYi8tinipWTDA=";
      type = "gem";
    };
    version = "1.0.1";
  };
  ffi-yajl = {
    dependencies = [ "libyajl2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-abqmEic5keTHlmdGTrJfP+sWmJmqszkpozsDI0ryQzY=";
      type = "gem";
    };
    version = "2.6.0";
  };
  fiber-annotation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-er+t8dEZ9QiGfUEDvyMcA1TQGcw5pXOJRd7C7a2vbAM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = [ "fiber-storage" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yIX5TyEPubBXN95l1RETbqYC4AxRBZU3SKoPh5NInwY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AvcnQv0+WBgWW1RVtX9bU2z2iQgjNTHNxu6JS+LJriw=";
      type = "gem";
    };
    version = "0.1.2";
  };
  find_a_port = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YF1qhLXm8TjaKwbIfFpKAjHk/cm5qSAi2cqjYfd9XOs=";
      type = "gem";
    };
    version = "1.0.1";
  };
  flipper = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/VxKZJQ0ZDNYc22EQp6QPPlnjRknw6sUvHUl7UBi+Gk=";
      type = "gem";
    };
    version = "0.28.3";
  };
  flipper-active_record = {
    dependencies = [
      "activerecord"
      "flipper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xqkcJl2oBit1z1dXCOMluTHiSOX4FYL+qMTN9GGtGSA=";
      type = "gem";
    };
    version = "0.28.3";
  };
  flipper-active_support_cache_store = {
    dependencies = [
      "activesupport"
      "flipper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ERriBXmSAgbwAdSzOp2Wdw/SPHCb7rbKE2yevJb72f0=";
      type = "gem";
    };
    version = "0.28.3";
  };
  fog-aliyun = {
    dependencies = [
      "addressable"
      "aliyun-sdk"
      "fog-core"
      "fog-json"
      "ipaddress"
      "xml-simple"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jyM0YEvreB6vu5zV9QFB+7LH63fH8rAfRcLgTbDlzDg=";
      type = "gem";
    };
    version = "0.4.0";
  };
  fog-aws = {
    dependencies = [
      "base64"
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dRMWXzDL57fC9fYMfzBAnVs9QAQ/fQJrobixu6t8x7g=";
      type = "gem";
    };
    version = "3.27.0";
  };
  fog-core = {
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U+XXk1VNcIDQFe8TzUS1QCfkIdkk2dukzj2D+V837ak=";
      type = "gem";
    };
    version = "2.1.0";
  };
  fog-google = {
    dependencies = [
      "addressable"
      "fog-core"
      "fog-json"
      "fog-xml"
      "google-apis-compute_v1"
      "google-apis-dns_v1"
      "google-apis-iamcredentials_v1"
      "google-apis-monitoring_v3"
      "google-apis-pubsub_v1"
      "google-apis-sqladmin_v1beta4"
      "google-apis-storage_v1"
      "google-cloud-env"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3NZOxdEu1T8mmv16iHOLRT5RUO9ytFGQC7er82eDWOA=";
      type = "gem";
    };
    version = "1.24.1";
  };
  fog-json = {
    dependencies = [
      "fog-core"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3U9as2LbxytockC7qdLdhB1d/oiKKFeXUz+FwD6lSP4=";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-local = {
    dependencies = [ "fog-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JjstCeVMadG4etfyNaGh5TyKZ07c7fdRLBcVdlrX73k=";
      type = "gem";
    };
    version = "0.8.0";
  };
  fog-xml = {
    dependencies = [
      "fog-core"
      "nokogiri"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Urn+oQcBRh3T6vnZg5cCFptBjbv1BCZ4a5t0+t43O9Y=";
      type = "gem";
    };
    version = "0.1.5";
  };
  formatador = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gIIYad2st55yhw/0uxUx76zSeMBPLfJrxrRSnuE1gr0=";
      type = "gem";
    };
    version = "0.2.5";
  };
  forwardable = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8X30vWr6b0agAyFwI/5XFu+IziYfXEzw7b3u1kcMr6w=";
      type = "gem";
    };
    version = "1.3.3";
  };
  fugit = {
    dependencies = [
      "et-orbi"
      "raabro"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6JSF574iIm2OnG2kEWZNBmAoS0scCMrLVA9QWQeGmGg=";
      type = "gem";
    };
    version = "1.11.1";
  };
  fuzzyurl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VC76gPK8qtvcQCwvC1cvLjNaHVPjda7K1ou7PYaGDA8=";
      type = "gem";
    };
    version = "0.9.0";
  };
  gapic-common = {
    dependencies = [
      "faraday"
      "faraday-retry"
      "google-protobuf"
      "googleapis-common-protos"
      "googleapis-common-protos-types"
      "googleauth"
      "grpc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rzBHBLRA96Kh6M5uzOEJpnt5+hc/NvEbUTuKNc5Qk2Y=";
      type = "gem";
    };
    version = "0.20.0";
  };
  gdk-toogle = {
    dependencies = [
      "haml"
      "rails"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OLiXJXbTJMCQXlopNVksIew2vttL8ebRlSV+4g660kk=";
      type = "gem";
    };
    version = "0.9.5";
  };
  gemoji = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gFU/L0kyp6lfsbPHxj992TfnyMYQFku96ij9Buul820=";
      type = "gem";
    };
    version = "3.0.1";
  };
  get_process_mem = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "puma"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sv08NkHdaoF8CYBsfW1QnYqZhFEqw43qi5F0Jrv3fro=";
      type = "gem";
    };
    version = "0.2.7";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A+x/cep+LPH9zV4IaC6YuBYBki/b7okLe8b2Ow4aUSo=";
      type = "gem";
    };
    version = "3.5.1";
  };
  gettext_i18n_rails = {
    dependencies = [ "fast_gettext" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KRznZKLbOUqLWlNM6gx3LBsfI4ZezFy/HPfqiCsjuY=";
      type = "gem";
    };
    version = "1.13.0";
  };
  git = {
    dependencies = [
      "addressable"
      "rchardet"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sKQi2fZRc1PEijMNYRTeTbngyC2+cgKWSh2fH7yCfXA=";
      type = "gem";
    };
    version = "1.19.1";
  };
  gitaly = {
    dependencies = [ "grpc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j2Wgxbs2lMkcn6S/p86r/BMYRreP7tjuMqdEqqz25wo=";
      type = "gem";
    };
    version = "18.1.0.pre.rc1";
  };
  gitlab = {
    dependencies = [
      "httparty"
      "terminal-table"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P2RePhldvCTwg0+/g+jM+yBW2OlxKwGmQKrUGKaUlnk=";
      type = "gem";
    };
    version = "4.19.0";
  };
  gitlab-active-context = {
    dependencies = [
      "activerecord"
      "activesupport"
      "connection_pool"
      "elasticsearch"
      "opensearch-ruby"
      "pg"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-active-context";
      type = "path";
    };
    version = "0.0.1";
  };
  gitlab-backup-cli = {
    dependencies = [
      "activerecord"
      "activesupport"
      "addressable"
      "bigdecimal"
      "concurrent-ruby"
      "faraday"
      "google-cloud-storage_transfer"
      "google-protobuf"
      "googleauth"
      "grpc"
      "json"
      "jwt"
      "logger"
      "minitest"
      "mutex_m"
      "parallel"
      "pg"
      "rack"
      "rainbow"
      "rexml"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-backup-cli";
      type = "path";
    };
    version = "0.0.1";
  };
  gitlab-chronic = {
    dependencies = [ "numerizer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-okTRGhOW0qrGrpsvMmrfFgXsGtIMKfBui2cgR9QVqaw=";
      type = "gem";
    };
    version = "0.10.6";
  };
  gitlab-cloud-connector = {
    dependencies = [
      "activesupport"
      "jwt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uer1VEzrtmZnvlYMwDL9bibMtsNcCRKzzR+tt8vPvzQ=";
      type = "gem";
    };
    version = "1.17.0";
  };
  gitlab-crystalball = {
    dependencies = [
      "git"
      "ostruct"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vTFHQqicrYy4WP7EH8UoL/ZMzyYs/6HVsRjwU8XDgqg=";
      type = "gem";
    };
    version = "1.1.0";
  };
  gitlab-dangerfiles = {
    dependencies = [
      "danger"
      "danger-gitlab"
      "rake"
    ];
    groups = [
      "danger"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1cBQ9oXYcg9ucBkafRIWhU2GDb3qW0Vfh6vnVC4AV5g=";
      type = "gem";
    };
    version = "4.9.2";
  };
  gitlab-duo-workflow-service-client = {
    dependencies = [ "grpc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/gitlab-duo-workflow-service-client";
      type = "path";
    };
    version = "0.2";
  };
  gitlab-experiment = {
    dependencies = [
      "activesupport"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8jDudCFUgFp1XV8lOdxE2Tzf8Ixbu7dlYBjWH5PQH0g=";
      type = "gem";
    };
    version = "0.9.1";
  };
  gitlab-fog-azure-rm = {
    dependencies = [
      "faraday"
      "faraday-follow_redirects"
      "faraday-net_http_persistent"
      "fog-core"
      "fog-json"
      "mime-types"
      "net-http-persistent"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Map8IXD1eHQFMUTn9xbsnhXzLnH/vSxWdT3ORuLni6k=";
      type = "gem";
    };
    version = "2.2.0";
  };
  gitlab-glfm-markdown = {
    dependencies = [ "rb_sys" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kcjpxhx41J8eUtu0np/S15CklKJUvIrVQATa3wkeLRs=";
      type = "gem";
    };
    version = "0.0.31";
  };
  gitlab-housekeeper = {
    dependencies = [
      "activesupport"
      "awesome_print"
      "httparty"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-housekeeper";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-http = {
    dependencies = [
      "activesupport"
      "concurrent-ruby"
      "httparty"
      "ipaddress"
      "net-http"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-http";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-kas-grpc = {
    dependencies = [ "grpc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+LSRfCPK5ltPrrnCuta3qjiDF3Zr92yiOG3Ek1kwX1M=";
      type = "gem";
    };
    version = "17.11.3";
  };
  gitlab-labkit = {
    dependencies = [
      "actionpack"
      "activesupport"
      "grpc"
      "jaeger-client"
      "opentracing"
      "pg_query"
      "redis"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0t0KYNshSamo7r8pddwj9UrDzrAb26cy6xsmuG3/+nA=";
      type = "gem";
    };
    version = "0.37.0";
  };
  gitlab-license = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LB+K5zg1ZA7He/dYwdDJcwY1BDwBz3eQL3l26CbX0BY=";
      type = "gem";
    };
    version = "2.6.0";
  };
  gitlab-mail_room = {
    dependencies = [
      "jwt"
      "net-imap"
      "oauth2"
      "redis"
      "redis-namespace"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BcB9uJIJTPV0fqAK+wqVxaVAbgXzSud59DiPLd+WIxY=";
      type = "gem";
    };
    version = "0.0.27";
  };
  gitlab-markup = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lRochxRjqPMp5sACstozfNVH/rzB4z2E30ohJBn7oC4=";
      type = "gem";
    };
    version = "2.0.0";
  };
  gitlab-net-dns = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tkr7sKXU0adzBpM8rCPztQdmfVSmlo2rb/6RsevGtac=";
      type = "gem";
    };
    version = "0.12.0";
  };
  gitlab-rspec = {
    dependencies = [
      "activerecord"
      "activesupport"
      "rspec"
    ];
    groups = [
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-rspec";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-rspec_flaky = {
    dependencies = [
      "activesupport"
      "rspec"
    ];
    groups = [
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-rspec_flaky";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-safe_request_store = {
    dependencies = [
      "rack"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-safe_request_store";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-schema-validation = {
    dependencies = [
      "diffy"
      "pg_query"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-schema-validation";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-sdk = {
    dependencies = [
      "activesupport"
      "rake"
      "snowplow-tracker"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SLpJCE9KuS33x++fNHAg2d/fbtnB54K2cmTpj/5upxA=";
      type = "gem";
    };
    version = "0.3.1";
  };
  gitlab-secret_detection = {
    dependencies = [
      "grpc"
      "grpc_reflection"
      "parallel"
      "re2"
      "sentry-ruby"
      "stackprof"
      "toml-rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7fM21ZS7f6V+W61bZX14badf4C4kBlgDxuUYFjcCiSw=";
      type = "gem";
    };
    version = "0.29.1";
  };
  gitlab-security_report_schemas = {
    dependencies = [
      "activesupport"
      "json_schemer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MAA3SH7J1RqBT2SFFP9SHLgrlPxR2f5TOJF1s2rGgK4=";
      type = "gem";
    };
    version = "0.1.2.min15.0.0.max15.2.1";
  };
  gitlab-sidekiq-fetcher = {
    dependencies = [
      "json"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/sidekiq-reliable-fetch";
      type = "path";
    };
    version = "0.12.1";
  };
  gitlab-styles = {
    dependencies = [
      "rubocop"
      "rubocop-capybara"
      "rubocop-factory_bot"
      "rubocop-graphql"
      "rubocop-performance"
      "rubocop-rails"
      "rubocop-rspec"
      "rubocop-rspec_rails"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RsfFcpYWNVhot7QKT/zQUrNjRgdgQqvoyvruFojL8sE=";
      type = "gem";
    };
    version = "13.1.0";
  };
  gitlab-topology-service-client = {
    dependencies = [
      "google-protobuf"
      "grpc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/gitlab-topology-service-client";
      type = "path";
    };
    version = "0.1";
  };
  gitlab-utils = {
    dependencies = [
      "actionview"
      "activesupport"
      "addressable"
      "rake"
    ];
    groups = [ "monorepo" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/gitlab-utils";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab_chronic_duration = {
    dependencies = [ "numerizer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DXZpRNQVtcgx8XaHHuhiV4P8DFv77y15o6YW8gf/wW0=";
      type = "gem";
    };
    version = "0.12.0";
  };
  gitlab_omniauth-ldap = {
    dependencies = [
      "net-ldap"
      "omniauth"
      "pyu-ruby-sasl"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u00grLOxI+1lSo9qR9P6xnPs5+0LaZLtuS3KFLrSg4w=";
      type = "gem";
    };
    version = "2.2.0";
  };
  gitlab_quality-test_tooling = {
    dependencies = [
      "activesupport"
      "amatch"
      "fog-google"
      "gitlab"
      "http"
      "influxdb-client"
      "nokogiri"
      "parallel"
      "rainbow"
      "rspec-parameterized"
      "table_print"
      "zeitwerk"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aOUY9x2FmBvcCW2NvTNpyF9UovudMRWguQ758UyEUBc=";
      type = "gem";
    };
    version = "2.10.0";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-szfhdG8MjLCmyRgjSwOh3etJZiBs4oj7tXd59ZstFU8=";
      type = "gem";
    };
    version = "1.1.0";
  };
  gon = {
    dependencies = [
      "actionpack"
      "i18n"
      "multi_json"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-46YY1lk5KJDxqn20IPF8df19Na61+P4ANpfQLEuI0vA=";
      type = "gem";
    };
    version = "6.4.0";
  };
  google-apis-androidpublisher_v3 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1+HX3ZL3nEmP4ggiIqF0DXiOAi5mDBNVZLP9KZyrVCU=";
      type = "gem";
    };
    version = "0.34.0";
  };
  google-apis-cloudbilling_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2ytyrr3CZk/VCVJkoWDPdXEZujqDoDaBe3jQ0q14hv0=";
      type = "gem";
    };
    version = "0.22.0";
  };
  google-apis-cloudresourcemanager_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8KRyoijAubWSdBOAznnq0kWOoAZqS1p4Y1gYubYu+78=";
      type = "gem";
    };
    version = "0.31.0";
  };
  google-apis-compute_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QEUUVIq8OkT16WOT1qbViNKHVI7Lb1qIatduG+6ngGg=";
      type = "gem";
    };
    version = "0.57.0";
  };
  google-apis-container_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eB0lFMsnJovpz7rlfLxCA5Zq+yz48sY2Mm9bxgOGJCQ=";
      type = "gem";
    };
    version = "0.43.0";
  };
  google-apis-container_v1beta1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aMSPz4jbkmzqsW9WiQyFiQJp5jZrJy/N6ViptVUDE9A=";
      type = "gem";
    };
    version = "0.43.0";
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
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7S5NSi4OJBttW1Rb+y1wacqL4cZ2bGBaCRNKn5k3nrI=";
      type = "gem";
    };
    version = "0.11.2";
  };
  google-apis-dns_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XdJz14qzfQPRvAeDcYb3mtA5np8rix7CYp7Wguo0fUc=";
      type = "gem";
    };
    version = "0.36.0";
  };
  google-apis-iam_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dbfih2tdDWNugya6prnPHN3Vi2BxUeXbH+j9AImaH2Y=";
      type = "gem";
    };
    version = "0.36.0";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6aJWptgPv8d9RL1+ZbyUueHphjoA5tQT7cAQLWy1VRs=";
      type = "gem";
    };
    version = "0.15.0";
  };
  google-apis-monitoring_v3 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Z3/h3OW0zJN4EzA7Agli//uG9QofYfZCJRaTe1rUYSg=";
      type = "gem";
    };
    version = "0.54.0";
  };
  google-apis-pubsub_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hf5GFMeBJQoNRJG+Q+E0k21cCK3HWoQ+J9S7Zro8sgU=";
      type = "gem";
    };
    version = "0.45.0";
  };
  google-apis-serviceusage_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xwt+AjZH59oH9rzmraCmsar9tUWhrphduskht20RsGI=";
      type = "gem";
    };
    version = "0.28.0";
  };
  google-apis-sqladmin_v1beta4 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VRVTtkgYefHNOfuDzCosLqkzSvxL8mG5aQDdVZ+WdJ0=";
      type = "gem";
    };
    version = "0.41.0";
  };
  google-apis-storage_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-natBCrRnHtjr9zbX609GQfoHKtMqI9NMJSwQ1x8Wg8w=";
      type = "gem";
    };
    version = "0.29.0";
  };
  google-cloud-artifact_registry-v1 = {
    dependencies = [
      "gapic-common"
      "google-cloud-errors"
      "google-cloud-location"
      "grpc-google-iam-v1"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoDS3Ol2fmY5Md7Xkpt/i/WYOm4upoB44n58qalAeD4=";
      type = "gem";
    };
    version = "0.11.0";
  };
  google-cloud-common = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c42wj9FEtP43tFeP/WMwi2Sob9WfaXnSQASPkXpvtfs=";
      type = "gem";
    };
    version = "1.1.0";
  };
  google-cloud-compute-v1 = {
    dependencies = [
      "gapic-common"
      "google-cloud-common"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uWBZsz/8LyVkTSAWGgwaoTMRlwc8LkR4axj4tnDxFB4=";
      type = "gem";
    };
    version = "2.6.0";
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
      hash = "sha256-dIAopIUw6lvOFZci63oCzQVi8cUvBWnp7WnaPLprTzU=";
      type = "gem";
    };
    version = "1.7.0";
  };
  google-cloud-env = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z0u4x9UX7h6mkrrt8G4LVs5oAHVJ2NWmZIGqn5f0aZk=";
      type = "gem";
    };
    version = "2.1.1";
  };
  google-cloud-errors = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RQtoHiTAiaIHIaAazEQIu0p7DfKMF1qqtIjakXSA1ks=";
      type = "gem";
    };
    version = "1.3.0";
  };
  google-cloud-location = {
    dependencies = [
      "gapic-common"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OGyZyhVuXKxBNzHAVdfZxVYphgEprXZYor856lAE0tA=";
      type = "gem";
    };
    version = "0.6.0";
  };
  google-cloud-profiler-v2 = {
    dependencies = [
      "gapic-common"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U/wqsXXQj1QjPGRDENR3mP6smWIgkWgVxPtEyTe10+M=";
      type = "gem";
    };
    version = "0.4.0";
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
      hash = "sha256-8oCr2k5gj56RQz+d2Qe+SkXNvyUf/rJ11xNUjlFcYwA=";
      type = "gem";
    };
    version = "1.45.0";
  };
  google-cloud-storage_transfer = {
    dependencies = [
      "google-cloud-core"
      "google-cloud-storage_transfer-v1"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EykB9QiJ4CoNN45hF8ZAjL/E/b0VydMfq+xPQYnvFlg=";
      type = "gem";
    };
    version = "1.2.0";
  };
  google-cloud-storage_transfer-v1 = {
    dependencies = [
      "gapic-common"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nb74AnXbVW4Ea7JBOcplWa/+ZB0eOLJTe4yq8viJYXY=";
      type = "gem";
    };
    version = "0.8.0";
  };
  google-protobuf = {
    groups = [
      "default"
      "development"
      "opentelemetry"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ECyFAFAuIkpdqnRHvdLEWKJabHsL9dhJalWa2hMZUrc=";
      type = "gem";
    };
    version = "3.25.8";
  };
  googleapis-common-protos = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "grpc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2iOA+1qxVjWAgWx06NaErBdRLDZUyCmj7oT21hOd44I=";
      type = "gem";
    };
    version = "1.4.0";
  };
  googleapis-common-protos-types = {
    dependencies = [ "google-protobuf" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XjdLBrz8fhNVbnwNh7mfH6PULeY5ah3j2PwTrvtN0H8=";
      type = "gem";
    };
    version = "1.20.0";
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
  gpgme = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U+zNcEKrtP1cePMLye0HWxMl5kUOqyB/L2oefiiuO2Q=";
      type = "gem";
    };
    version = "2.0.24";
  };
  grape = {
    dependencies = [
      "activesupport"
      "builder"
      "dry-types"
      "mustermann-grape"
      "rack"
      "rack-accept"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ou/5TBfoTM6tT/mIM99pHn2gwQiHjMEoyjH4DBBHSUo=";
      type = "gem";
    };
    version = "2.0.0";
  };
  grape-entity = {
    dependencies = [
      "activesupport"
      "multi_json"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4A+elOQHr/d6opRddB9UTQfkhQGSeUKYh5mRMVHQJjQ=";
      type = "gem";
    };
    version = "1.0.1";
  };
  grape-path-helpers = {
    dependencies = [
      "activesupport"
      "grape"
      "rake"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rVIW5SxueWc4qRGAhzUqtMlikA260dj4wPluCTxnAtc=";
      type = "gem";
    };
    version = "2.0.1";
  };
  grape-swagger = {
    dependencies = [
      "grape"
      "rack-test"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ite9U8i67nBFdYCIdduowI0mnEV9s8+PG4oqHb+CcpQ=";
      type = "gem";
    };
    version = "2.1.2";
  };
  grape-swagger-entity = {
    dependencies = [
      "grape-entity"
      "grape-swagger"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oqDrKJZLGlZ3WjVxNYqfCjALcD267h7lNa2yp77X7OY=";
      type = "gem";
    };
    version = "0.5.5";
  };
  grape_logging = {
    dependencies = [
      "grape"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-78w+Mi29XWIKaPB4czt9sEPPEmgBRM0DyYLxQRXHktE=";
      type = "gem";
    };
    version = "1.8.4";
  };
  graphlyte = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ta9Ktn3ebpYfAOocGPFZ9ztS7RE5W7Ts4pf+Yo+hgE0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  graphql = {
    dependencies = [
      "base64"
      "fiber-storage"
      "logger"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+x226eJMk8mV+Ag9Zuxl6nCZGqK2jaGxWjYLQYr1qp0=";
      type = "gem";
    };
    version = "2.4.13";
  };
  graphql-docs = {
    dependencies = [
      "commonmarker"
      "escape_utils"
      "extended-markdown-filter"
      "gemoji"
      "graphql"
      "html-pipeline"
      "sass-embedded"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-drrKblqAOktqn7u/2/FnQrfExUbIWStuGnqk555WLQQ=";
      type = "gem";
    };
    version = "5.0.0";
  };
  grpc = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VvoNovT5ZHH1lDCp7wimEsx3ZJ6PoRjIOufQu2Gb6gk=";
      type = "gem";
    };
    version = "1.72.0";
  };
  grpc-google-iam-v1 = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos"
      "grpc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zqNW0VDaxpdR9qTHHxVxyAIsadn0zpwYE5IAkywZN04=";
      type = "gem";
    };
    version = "1.5.0";
  };
  grpc_reflection = {
    dependencies = [ "grpc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vEffEveUpAdjO1qesn/ZURinjXAcMlJW//PJ5QgZCXs=";
      type = "gem";
    };
    version = "0.1.1";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "kerberos" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xRzzCELuOb2Tzn/DPiBAX/igTNqd7GCSBxthJYKEruE=";
      type = "gem";
    };
    version = "1.3.1";
  };
  guard = {
    dependencies = [
      "formatador"
      "listen"
      "lumberjack"
      "nenv"
      "notiffany"
      "pry"
      "shellany"
      "thor"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cbp6ut3syL6Rq3e7r3j3ZyRmA2Uuu8e5dv2kl+vcj7s=";
      type = "gem";
    };
    version = "2.16.2";
  };
  guard-compat = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OtIasAcBB/ku39gmELXNwvuONohR5yNiralwNEPWRv4=";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-rspec = {
    dependencies = [
      "guard"
      "guard-compat"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pHugPL0ePHHmroZFzql+IDCYokiu3lB0YaQ+kG4vdco=";
      type = "gem";
    };
    version = "4.7.3";
  };
  haml = {
    dependencies = [
      "temple"
      "tilt"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bnWSRlVhRWQu+DLWcPwG+b2FORWaDmAIR6ACkd16rgw=";
      type = "gem";
    };
    version = "5.2.2";
  };
  haml_lint = {
    dependencies = [
      "haml"
      "parallel"
      "rainbow"
      "rubocop"
      "sysexits"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5SYu7mgoSLm9ic09IOsO/a8xJnYq2T5nB8mFjrOr72E=";
      type = "gem";
    };
    version = "0.62.0";
  };
  hamlit = {
    dependencies = [
      "temple"
      "thor"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0uhQU2IziUX6MJxosri+B+vcGBIA7GAhIjVnv2baw44=";
      type = "gem";
    };
    version = "2.15.0";
  };
  hana = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VCXbQtZR/qCIWYEcKdIERvFq8ZYwgWKJTbIIysXOmw0=";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUZfDnN18e6IP1OnZuzk28dkt2dKfF/9duebL19vyck=";
      type = "gem";
    };
    version = "1.1.0";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  health_check = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EBRlCCN9xU7X4kwpLYun+4+VkM8mxm4yW5R0OMQQO1c=";
      type = "gem";
    };
    version = "3.1.0";
  };
  heapy = {
    dependencies = [ "thor" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dBQehF1h/8fB6L+LEnyM+UVE7HoRga7GEyiGglQ1heo=";
      type = "gem";
    };
    version = "0.2.0";
  };
  html-pipeline = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ih1NcSiyFBkTOHysD4uomLtoElVwAazAwrRpEPWUE6A=";
      type = "gem";
    };
    version = "2.14.3";
  };
  html2text = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-McLwvpq3qk/HgLB9X4SILrwiqQJMKaRfT1rf5C6SrU8=";
      type = "gem";
    };
    version = "0.2.0";
  };
  htmlbeautifier = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-neDJhID+gNeV7Vc0oR8YNWPNlpaG8loEYJwPWkRvpfg=";
      type = "gem";
    };
    version = "1.4.2";
  };
  htmlentities = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Elpzxsny0bYhALfDxAHjYkRBtmN2Kvp/5ChHZDWmc9o=";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = [
      "addressable"
      "http-cookie"
      "http-form_data"
      "llhttp-ffi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/K7BSk+C3m0vnLl4wHMmgUxsK0K4l09uwWb/GcZF668=";
      type = "gem";
    };
    version = "5.1.1";
  };
  http-accept = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xiaGBoK/uztGRi+MOc1HD9ewWE9hs8yd9bLp65lyoSY=";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c3VtRsfb3HAj3uzbihcTSOqVobmYELMc/otPtOmmMY8=";
      type = "gem";
    };
    version = "1.0.5";
  };
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zE7rE2HZh2gh4x17HPC2jxz4dLIB0nkDSAR52GRIpfM=";
      type = "gem";
    };
    version = "2.3.0";
  };
  httparty = {
    dependencies = [
      "csv"
      "mini_mime"
      "multi_xml"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OsHdYvIBD27OVRcW9c7sKyASAR2J8XUZF6t/ck6Wa1U=";
      type = "gem";
    };
    version = "0.23.1";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KVHkmRIURkw+khB+RkOFJ9IwSOY0867pHHGeC9+uvaY=";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x97t6tCGbqkQKXWk6reWj1PeUHk6DCEaN4CPdd0YdVE=";
      type = "gem";
    };
    version = "1.14.4";
  };
  i18n_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5aqZsJpptGO7BEP8H5VANRpJ89FUHF6RMWuvoDXGP2Y=";
      type = "gem";
    };
    version = "0.13.1";
  };
  icalendar = {
    dependencies = [
      "ice_cube"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dr/CZy+fp3uGtNjA4l6bIxmq1FozMZ/tBtC+jd0M1IU=";
      type = "gem";
    };
    version = "2.10.3";
  };
  ice_cube = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2hF+XeJL3DOTG+Yp+bVQSGQZJEQsfpty/twF5VklMbc=";
      type = "gem";
    };
    version = "0.16.4";
  };
  ice_nine = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XVBqfScj1VktwSG5ko5JMXQnMBMfIqGjdknfHB4uY9s=";
      type = "gem";
    };
    version = "0.11.2";
  };
  imagen = {
    dependencies = [ "parser" ];
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Np/pEgeId9upJhXr/G81p9gz4x8k9HvdOtU3GkE54ks=";
      type = "gem";
    };
    version = "0.2.0";
  };
  influxdb-client = {
    dependencies = [ "csv" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3B6OyAVC9kyfMa9tm/pMFHR0vzK5F5p/DKuXB5O44fI=";
      type = "gem";
    };
    version = "3.2.0";
  };
  invisible_captcha = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ArRS8+sbaR0VW6Po6X4b4Oa2vmLovJSVcjS5zeCFKx4=";
      type = "gem";
    };
    version = "2.1.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TCYrZhCtZDor516JITWspPpn7cZ9GUTArmtuXdc/T8E=";
      type = "gem";
    };
    version = "1.9.0";
  };
  ipaddress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWQMT5GUwmk3r8jHjjB0qOfJfV0SEDWNFEDwEDTQBvU=";
      type = "gem";
    };
    version = "0.8.3";
  };
  ipynbdiff = {
    dependencies = [
      "diffy"
      "oj"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/gems/ipynbdiff";
      type = "path";
    };
    version = "0.4.8";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2bynRaxCB6i3KKUrmLdmypCbhv8aUEvN49b4yE+q6JA=";
      type = "gem";
    };
    version = "1.15.1";
  };
  jaeger-client = {
    dependencies = [
      "opentracing"
      "thrift"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y16bm77m7o1qgtA9lHpbBFQ9jAqUnCLkhCVPGNikWKg=";
      type = "gem";
    };
    version = "1.1.0";
  };
  jaro_winkler = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wFa2G79/H8AVG958j1iaLWZtQtDNuIk5W5tzsyjhs5M=";
      type = "gem";
    };
    version = "1.6.1";
  };
  jira-ruby = {
    dependencies = [
      "activesupport"
      "atlassian-jwt"
      "multipart-post"
      "oauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q/Jua/9KjqQLrgb332J2pXdpBcY/sgcJNII8pU9i62I=";
      type = "gem";
    };
    version = "2.3.0";
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
  js_regex = {
    dependencies = [
      "character_set"
      "regexp_parser"
      "regexp_property_values"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eTS83VoObVr0pSAoj9RoSgKkcq5Vgx2ReMyvgjVjRLU=";
      type = "gem";
    };
    version = "3.8.0";
  };
  json = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mhD2WKLeZ8Drg363ld1IEyznl8QD5Stevvh9zcf5zME=";
      type = "gem";
    };
    version = "2.11.3";
  };
  json-jwt = {
    dependencies = [
      "activesupport"
      "aes_key_wrap"
      "base64"
      "bindata"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q0UfnNh0POzEE39BcIBgRsHYptTuboVw4LXJWECbJmw=";
      type = "gem";
    };
    version = "1.16.6";
  };
  json_schemer = {
    dependencies = [
      "bigdecimal"
      "hana"
      "regexp_parser"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nx+hc7hZylIPFeno0IsIkv/KgLeN2CIf6z42D/TN6zU=";
      type = "gem";
    };
    version = "2.3.0";
  };
  jsonb_accessor = {
    dependencies = [
      "activerecord"
      "activesupport"
      "pg"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AQ4IfLhD52tqYk1or5GKjv1rD/KuJbbwrOvf6kX3dqs=";
      type = "gem";
    };
    version = "1.4";
  };
  jsonpath = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aAQSTCRNBEGCGKy4WxXHyqecWS19aXAZUwBChFiUbTo=";
      type = "gem";
    };
    version = "1.1.2";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Vf0HzN1kxiLTaFl0jyKQ+5wRnOMLSChnUE6fEmVNamU=";
      type = "gem";
    };
    version = "2.9.3";
  };
  kaminari = {
    dependencies = [
      "activesupport"
      "kaminari-actionview"
      "kaminari-activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xAdv+a3MxhCUCDM/h7XEq72l453EZL1MZtBtn3NEKj4=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-actionview = {
    dependencies = [
      "actionview"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EzD2/ItZpKTvalSf+KIkeXKJ6/ejpQPowWUlNSh8yQk=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-activerecord = {
    dependencies = [
      "activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DdOme6s1ajVvNrO3I2vLgc7zEwlTZb7+jpgFfdJHJDA=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-O9Jv7HNwZFr0DKc7lCakSNCbiounr6m6PD4NOc27g/8=";
      type = "gem";
    };
    version = "1.2.2";
  };
  knapsack = {
    dependencies = [ "rake" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qUImiHUZidCaQLS/f5WacaO/57xJ081hDC/PtuRUgrg=";
      type = "gem";
    };
    version = "4.0.0";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-h7u2q9nTzr5PwfM+Nnw5K0UA5vj6Gd1hwJcs9K/nNow=";
      type = "gem";
    };
    version = "2.5.1";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+zl0VRZCfSmIVDvwH8TPCrEUlHY4I5Pg6cSFkvZYFyk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  kubeclient = {
    dependencies = [
      "http"
      "jsonpath"
      "recursive-open-struct"
      "rest-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SYX810n7jDZKZoqDUKSYIWR/A6pS2e5svFgr646IP8w=";
      type = "gem";
    };
    version = "4.11.0";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PVxYwC9Eog2XKVep/r44bX50aKs5AM5r0rVj3ZEMaz8=";
      type = "gem";
    };
    version = "3.17.0.3";
  };
  launchy = {
    dependencies = [ "addressable" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iqBEFlWuxVFACOHQSJLC3jule9M3r7mEVo2gkRIaJBs=";
      type = "gem";
    };
    version = "2.5.2";
  };
  lefthook = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZO7jPa9Rbye4lIyXNOSV10C6mqIRqtzzTDXPsQCPuqI=";
      type = "gem";
    };
    version = "1.11.13";
  };
  letter_opener = {
    dependencies = [ "launchy" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/M/LjtcPCbRlZvlSzlcCGym1Egm6L9BoU/5b98b27I=";
      type = "gem";
    };
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = [
      "actionmailer"
      "letter_opener"
      "railties"
      "rexml"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Pzke/g6LmyS+z6tVN9+xelz161MgOPlH2qtYy0t0mGA=";
      type = "gem";
    };
    version = "3.0.0";
  };
  libyajl2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ql32xyV3b8BQyEGEUN4PfBKctyALgRkHxMCztcCuoO8=";
      type = "gem";
    };
    version = "2.1.0";
  };
  license_finder = {
    dependencies = [
      "csv"
      "rubyzip"
      "thor"
      "tomlrb"
      "with_env"
      "xml-simple"
    ];
    groups = [
      "development"
      "omnibus"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F56tGbZLFwY4ty/RYCQjOBNnOsnSDVunWuC0REiH7xQ=";
      type = "gem";
    };
    version = "7.2.1";
  };
  licensee = {
    dependencies = [
      "dotenv"
      "octokit"
      "reverse_markdown"
      "rugged"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PoPbmE+35OUcmP6g5DQTjcthEvjCbcdpNzSk+N+Z33c=";
      type = "gem";
    };
    version = "9.18.0";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-O4DKp6p3+ug2kWwvnj+8r70V9daV3Uh8H1tefkZe/ik=";
      type = "gem";
    };
    version = "3.7.1";
  };
  llhttp-ffi = {
    dependencies = [
      "ffi-compiler"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5fcyfbPPgAfmSDQu92NH1uCuVFqEAuUZzKnIhus3sAE=";
      type = "gem";
    };
    version = "0.4.0";
  };
  locale = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ui+Zc+8+7mSqybygbSHbL7pnX6PSz2HSH0LRyhip94A=";
      type = "gem";
    };
    version = "2.1.4";
  };
  lockbox = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yo5YBuTgxW0ddirFz0AZQP9T/DdVTvYj0zE8emMxo+o=";
      type = "gem";
    };
    version = "1.3.0";
  };
  logger = {
    groups = [
      "danger"
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  lograge = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TL0VVLhvVF15Xv8VoMJP0lBX0qxOHKpfwYYWiz2pMu8=";
      type = "gem";
    };
    version = "0.11.2";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZVowhCtw7EdkELNHqxzSpbktpGoZBENXu9n0AbAJozc=";
      type = "gem";
    };
    version = "2.24.1";
  };
  lookbook = {
    dependencies = [
      "activemodel"
      "css_parser"
      "htmlbeautifier"
      "htmlentities"
      "marcel"
      "railties"
      "redcarpet"
      "rouge"
      "view_component"
      "yard"
      "zeitwerk"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FkhMnrUUrAwjxLWc/VpSaXFB01BW46nCoisxTBuIdgU=";
      type = "gem";
    };
    version = "2.3.4";
  };
  lru_redux = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7nHQzKsWTFHeFGwntICmizYx1bQpe4/+jtocct6Hr/s=";
      type = "gem";
    };
    version = "1.1.0";
  };
  lumberjack = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pcaq5rQjTxQg282Asj47yggXvSOUQN3gl+vj+mPGOx8=";
      type = "gem";
    };
    version = "1.2.7";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  mail-smtp_pool = {
    dependencies = [
      "connection_pool"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/mail-smtp_pool";
      type = "path";
    };
    version = "0.1.0";
  };
  marcel = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oBO2d+9Gy8tJ/VxZs9NYA9LuBN112L/cQ1M/xaMffk4=";
      type = "gem";
    };
    version = "1.0.2";
  };
  marginalia = {
    dependencies = [
      "actionpack"
      "activerecord"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y2MhKrY+QnRuJ1lekSyyBAihoovNDt3lXRW3xF+iic8=";
      type = "gem";
    };
    version = "1.11.1";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  memory_profiler = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OM20LyLZEA3y66A2XBmXJLWLBcOOdlzXZKBzkpFpAbE=";
      type = "gem";
    };
    version = "1.0.1";
  };
  method_source = {
    groups = [
      "default"
      "development"
      "metrics"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-13lFWitWZqB5zlhXe/rYU09XGvfOyBB/Tc4yjwmB3t4=";
      type = "gem";
    };
    version = "1.0.0";
  };
  metrics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QuyO6tuSpXVJpyvdG6+G1CcAibxZiRe5PPnLb5X8wpw=";
      type = "gem";
    };
    version = "0.12.1";
  };
  microsoft_graph_mailer = {
    dependencies = [
      "mail"
      "oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/microsoft_graph_mailer";
      type = "path";
    };
    version = "0.1.0";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hddy+2zyH5mayAhZmBkvud1dFuhuxMacXnmsMANCDWE=";
      type = "gem";
    };
    version = "3.5.1";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D3uW1OVNF3Uu14OY3KlAI1nMrrORqgwOWzBb7a8CW3o=";
      type = "gem";
    };
    version = "3.2023.1003";
  };
  mini_histogram = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ahFLUE5GGLDgdsxnKZYDaHD3zG8WuOXCXAxjdybS3ZQ=";
      type = "gem";
    };
    version = "0.3.1";
  };
  mini_magick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZzAvqE5j8QArcUFqhGaWjtDzPSL11ClioMCanxw6kGo=";
      type = "gem";
    };
    version = "4.12.0";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pUrsDMdDigOoUK2wDayivbYHR/g54oGGmU3wV86ocVE=";
      type = "gem";
    };
    version = "1.1.2";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eOGKosScWOm8U8VKC5AOh60KljlOkvu/pY0/+GCmj0U=";
      type = "gem";
    };
    version = "5.11.3";
  };
  mixlib-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5vJ7401YD27XFzHKRrln5XeTpicTHB9uHtLa056jvfk=";
      type = "gem";
    };
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = [ "tomlrb" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-13SLGJjk8WUCr+wd4Ata1lxt5AURSxsMZexhsakQAUg=";
      type = "gem";
    };
    version = "3.0.27";
  };
  mixlib-log = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Kh0/qDUioyDt1JOCfJAbdz+10YX6x+/YHQKNjhFmp2g=";
      type = "gem";
    };
    version = "3.2.3";
  };
  mixlib-shellout = {
    dependencies = [ "chef-utils" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RvbR+cd+aJpEMIHFysM2IDND8PIiTbBrgNOa5M15fH4=";
      type = "gem";
    };
    version = "3.2.7";
  };
  mize = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QDFViXn/VCb9okx1oUm05MD69MrPL66JOPg4ZquUt4A=";
      type = "gem";
    };
    version = "0.6.1";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pT2zIPukD1jAfFtm7Z/U1zy+jrpMso/p4yGERDQaTgk=";
      type = "gem";
    };
    version = "1.5.4";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2XEpbA6s6iidMeSnq3rF7alyYsYrvIwRDeT142QlxXc=";
      type = "gem";
    };
    version = "1.14.1";
  };
  multi_xml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0kOTz5WK2yJtuIS5drAHkUqJxTrYhxjiVnnXAIgjrVI=";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ril53ilxuN8zwu55f9SXcxYXJB+dzZOWDMPKzLLdE9g=";
      type = "gem";
    };
    version = "2.2.3";
  };
  murmurhash3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Nwos4umrBxHlFVTlMLX2OVaSemVUopaFX0KhpKXtCTY=";
      type = "gem";
    };
    version = "0.1.7";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bTVpqjw7LwSMYGJvSNmy1WHMjS7yaSlpQ7A9oYHAi2c=";
      type = "gem";
    };
    version = "3.0.0";
  };
  mustermann-grape = {
    dependencies = [ "mustermann" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b1MJ1qM4+AHyEcZE6MLTzCV3qGk/nNUdrf2ynBJg9f4=";
      type = "gem";
    };
    version = "1.0.2";
  };
  mutex_m = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z8sErBa2nEgTd3Ai/c7aJOn3mOSAkqK4F+tMCngrB1E=";
      type = "gem";
    };
    version = "0.3.0";
  };
  nap = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lJaRZg+dBB11vmEbsqjS/VWcRnU33qwkH0CX2bXupXY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  nenv = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2d5tj7cHIihGO/YYQxWUGclp7bNLPO9RgytRaueXJ2U=";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bkKICzR+ZQ/+r2ea5ZydWm7YoizabhuVnZwnAFCu+o4=";
      type = "gem";
    };
    version = "4.0.5";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ht6ASO5oihQgYGC/N6cW0Yy26gCFX2ybFdrul+5R++U=";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-ldap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UlcbVfkVcSCDOsFmfylpzgE5JRgR0Km2RlfBwTUGnPk=";
      type = "gem";
    };
    version = "0.17.1";
  };
  net-ntp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W8c/QQK94NGHK9Oyk2CK6Z2fUAfXRPIZGcalZe2pJn0=";
      type = "gem";
    };
    version = "2.1.3";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rUPivpZe3mdmg8BHssPXZ2KqSadkd52YMSoQ2gRiLBQ=";
      type = "gem";
    };
    version = "0.1.3";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sy3tDUjIjOcIRKBj5OFO+0SpXlGp4MC/sMVLQxO2Iuo=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PVHcqpgbdK/y2Jy+id5FA7wtaCNl6lF2Nm6VCg1o1bA=";
      type = "gem";
    };
    version = "0.3.3";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FyB2xLMM5W+yWgOWGwxNoU4SRkJkAbD4nLoaO1S/PvA=";
      type = "gem";
    };
    version = "7.3.0";
  };
  netrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3hzjPajJmrHZeHFybLp1FRET8RcUa+y+RaqFyz2r7j8=";
      type = "gem";
    };
    version = "0.11.0";
  };
  nio4r = {
    groups = [
      "default"
      "puma"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lYamheyoJG1kBucSpSXnBdFbuI9wnXj8PxQehk35cnY=";
      type = "gem";
    };
    version = "2.7.0";
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
  no_proxy_fix = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TptMMbsUbef880fcEIe7E6wgObVtUKoBnmEDYlarzQA=";
      type = "gem";
    };
    version = "0.1.2";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  notiffany = {
    dependencies = [
      "nenv"
      "shellany"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03ZpYFt/jcsE4ATmNz4qeAuYx3b461A6yVeFV9eAhzg=";
      type = "gem";
    };
    version = "0.1.3";
  };
  numerizer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5YB21e5TcEF7flLZyyWDbWKs0bjZoZTDCHB5hsFwXXs=";
      type = "gem";
    };
    version = "0.2.0";
  };
  oauth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QIX+KODF4kNBNeAKZVUpT9Kk/5apjRvezc1hn8Y2jf8=";
      type = "gem";
    };
    version = "0.5.6";
  };
  oauth2 = {
    dependencies = [
      "faraday"
      "jwt"
      "logger"
      "multi_xml"
      "rack"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jxMmeVmNIYhdS8xo1+fm7wop+aeCq8oA1n2IQoDcOkI=";
      type = "gem";
    };
    version = "2.0.10";
  };
  observer = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2KMQcTG6ZhE410jnvj26/A2C5zL/+6n8yz14KYgJUKw=";
      type = "gem";
    };
    version = "0.1.2";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T6R/81zmVBJ+3yyDarkmm8yIKfVULcHoaHH2l85/QxY=";
      type = "gem";
    };
    version = "9.2.0";
  };
  ohai = {
    dependencies = [
      "chef-config"
      "chef-utils"
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "plist"
      "train-core"
      "wmi-lite"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Qu6BlpRcuTX97sk7p6rudX0dVS97kzkSofJYY8PMH/A=";
      type = "gem";
    };
    version = "18.1.18";
  };
  oj = {
    dependencies = [
      "bigdecimal"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KqtgnSvIllKb08cNc39ZHBOTKmQLphZKD35BTv2wUrE=";
      type = "gem";
    };
    version = "3.16.11";
  };
  oj-introspect = {
    dependencies = [ "oj" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XLsVMJ1gKUiB5cL2XOsi47V5jybQoeZa5HpjQrh9kmQ=";
      type = "gem";
    };
    version = "0.8.0";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
      "rack-protection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3vAydymLj4pdP/Fs2y617bm//tYO592iTMDImzrmoM4=";
      type = "gem";
    };
    version = "2.1.2";
  };
  omniauth-alicloud = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nFxPOrtA13S5RgFfF31QP73pmytXwIWChMJcw5NpAT4=";
      type = "gem";
    };
    version = "3.0.0";
  };
  omniauth-atlassian-oauth2 = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6wdXShiKuKAzds4oi86GvC3UoTgv+leBy14re8Fddsk=";
      type = "gem";
    };
    version = "0.2.0";
  };
  omniauth-auth0 = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PZ6DN3s3OU2wd88nCC0pzP+TFY8HLZL8WfHoh5jGwrI=";
      type = "gem";
    };
    version = "3.1.1";
  };
  omniauth-azure-activedirectory-v2 = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xITO3VLNIz48IWxLPtZn7AfSDlHFUKYTtloPkP6K0HI=";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth-github = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j/jnCsbW251SSF7vUs+olJOMlBSW5mtSteJ3Ot48ytQ=";
      type = "gem";
    };
    version = "2.0.1";
  };
  omniauth-gitlab = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/omniauth-gitlab";
      type = "path";
    };
    version = "4.0.0";
  };
  omniauth-google-oauth2 = {
    dependencies = [
      "jwt"
      "oauth2"
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RJbxJuhOr3YPnGpcaeXnUR+YCS1/Ja15/SwK5eCbUDk=";
      type = "gem";
    };
    version = "1.1.1";
  };
  omniauth-oauth2 = {
    dependencies = [
      "oauth2"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-svjpVZzH4tTvuldgdpHW0rY0uHn8W1tsz++j2oUInng=";
      type = "gem";
    };
    version = "1.8.0";
  };
  omniauth-oauth2-generic = {
    dependencies = [
      "omniauth-oauth2"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zm6FOQGdXr8vSIZwcrnySPFIu0y+cWbe5lWGWr+udhM=";
      type = "gem";
    };
    version = "0.2.8";
  };
  omniauth-salesforce = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/omniauth-salesforce";
      type = "path";
    };
    version = "1.0.5";
  };
  omniauth-saml = {
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1ODb3LME5Lt0QQ63XeqhhzsIpCr6djTJwxcb4LNHUbA=";
      type = "gem";
    };
    version = "2.2.3";
  };
  omniauth-shibboleth-redux = {
    dependencies = [ "omniauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6bNT/RA0BfzIVJ6FELnK2Fes8LKG12T6xduoqTq4/+E=";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth_crowd = {
    dependencies = [
      "activesupport"
      "nokogiri"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = "${src}/vendor/gems/omniauth_crowd";
      type = "path";
    };
    version = "2.4.0";
  };
  omniauth_openid_connect = {
    dependencies = [
      "omniauth"
      "openid_connect"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hy84kDhuKnQiIc7g0ukDt42HTm+rnqO/oxwUYvR5PSU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  open4 = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-od8DcxBiTsweodgSZLEcg+ltDDwcYEMQjTfTltzQ9LE=";
      type = "gem";
    };
    version = "1.3.4";
  };
  openid_connect = {
    dependencies = [
      "activemodel"
      "attr_required"
      "email_validator"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "mail"
      "rack-oauth2"
      "swd"
      "tzinfo"
      "validate_url"
      "webfinger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XYCDgM/4DXjj09VM+uvi1kYdg1xnT6op4jFKQCwbIYI=";
      type = "gem";
    };
    version = "2.3.1";
  };
  opensearch-ruby = {
    dependencies = [
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CoYhaGvtPFm0wj4Iy674c2haP+RWjp0nAxVcqSuMoF0=";
      type = "gem";
    };
    version = "3.4.0";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PEu4dgl3tL7NKBnGwlabz1xvSLMrn3pM4f03+ZY3jRQ=";
      type = "gem";
    };
    version = "3.2.0";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o7QLXoJ2Fi1KblDHyXza8URvmyw5Rqb6LBRijgyVfoA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  opentelemetry-api = {
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qz2aBWbNLuBoreQOhAvJczg6uFaOaTwMVxLwx4kSLMk=";
      type = "gem";
    };
    version = "1.2.5";
  };
  opentelemetry-common = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/okaRFg6ILwyF7MkrsdtBmUESUlRaC05HP1X1AzQHJg=";
      type = "gem";
    };
    version = "0.21.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-sdk"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MkTF9In07hkA27GXoV6O1J0Md3qqUqXNHR+zywoZDrA=";
      type = "gem";
    };
    version = "0.29.1";
  };
  opentelemetry-helpers-sql-obfuscation = {
    dependencies = [ "opentelemetry-common" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vG7xNz28+XlkcJGzv8mde2+5Zp90w64YT1i0it/I1DI=";
      type = "gem";
    };
    version = "0.1.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iPLdjP8niG6Eu/Uitpjwv4a4Pw8K2w09J7P6ghGxyw4=";
      type = "gem";
    };
    version = "0.2.0";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
      "opentelemetry-instrumentation-rack"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYIaRb5MKigc+kLsllYiaLUP9dX6x3OG5+OeeSvOqwI=";
      type = "gem";
    };
    version = "0.10.0";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bagpFU51G9iPU2m5emNG4Sw1g6eE9YF4zKoLRtMB6iE=";
      type = "gem";
    };
    version = "0.7.3";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KBs9m6znqsnx4SG3XylOfui+rt0fIEBVOcVN8uZ2OUI=";
      type = "gem";
    };
    version = "0.7.8";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vlgFR7VlPwXAsSyzTY2aIuSAKS7j0SFPdMV+LTjKSpE=";
      type = "gem";
    };
    version = "0.8.1";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T+ceK+IRNcSm64CGmYxQje7FAICQCCn7aV7gG5O1B+A=";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-aws_sdk = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o8N0sEu34PqLVFLlfKapyMFIf2qd1kPJWmBbPOxaGbU=";
      type = "gem";
    };
    version = "0.7.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-registry"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9hxDTwQGzch4vBiPZ+ZE+U26S+VT0v0hstH6qCcxYF8=";
      type = "gem";
    };
    version = "0.22.3";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BO/IEURZu9XRBLVZxBOu9C4SoaSJ5B3yt7iesfiHFM4=";
      type = "gem";
    };
    version = "0.21.4";
  };
  opentelemetry-instrumentation-ethon = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IPMEc3iOFgEGzC7Kojdy5PEjdlEnjbENnP9TXxGoQ1w=";
      type = "gem";
    };
    version = "0.21.9";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7A8bW1qAjmXXW8ORTJAQjrpsKd1uuZfG3muj/8OpifQ=";
      type = "gem";
    };
    version = "0.22.5";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Nt+F1tlE0oekVyZjTppn00Jqtueq+IYjk3VR48ay66s=";
      type = "gem";
    };
    version = "0.24.7";
  };
  opentelemetry-instrumentation-grape = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
      "opentelemetry-instrumentation-rack"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oSJdcwG37ujrmK4fqQ/oecWlTTYx33MdZYhjpP5VF7Y=";
      type = "gem";
    };
    version = "0.2.0";
  };
  opentelemetry-instrumentation-graphql = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ws/Muo1ENzPUpCoMXCwwHao08bOCsNoBZiVSgMcC3Gw=";
      type = "gem";
    };
    version = "0.28.4";
  };
  opentelemetry-instrumentation-http = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cfG0+acip0R+dbcxg1uDJTZznWg/vGthUyyzGNFjXh4=";
      type = "gem";
    };
    version = "0.23.5";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QR9FeBuJf8GiGgSvTZ3n4um3JZuKUA9cIwcJyd6PRWs=";
      type = "gem";
    };
    version = "0.22.8";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AjvWi2gkuPrlz5BfTID3NMMjlawteRHK26Emd5cwBC4=";
      type = "gem";
    };
    version = "0.22.8";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-helpers-sql-obfuscation"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jL/BcozXUi2lj/Xnv166TlsUnsrUEHamjnr5g4iaglI=";
      type = "gem";
    };
    version = "0.29.1";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U5yLT2uBjhZJXpAWEmU3tNHMUykiGfGsw1AG/jDOJD0=";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-action_mailer"
      "opentelemetry-instrumentation-action_pack"
      "opentelemetry-instrumentation-action_view"
      "opentelemetry-instrumentation-active_job"
      "opentelemetry-instrumentation-active_record"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UQaZ3ArN461B6/0Qk4QTtp7NpbLSe7Cb2kmASyMhbZY=";
      type = "gem";
    };
    version = "0.33.1";
  };
  opentelemetry-instrumentation-rake = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+96Kaqt3wJvw+U2RTdJtzy4j7GfiMA8GocuClKl9gCA=";
      type = "gem";
    };
    version = "0.2.2";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LqDy1F/hrwaJrq3Aj1szWittlGPenYVf0lMT08W0L+M=";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1qbiyt3f2goLZB+dyRjjWne/xivJC4B3b1GUvVXg3zE=";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-registry = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EWq2EUpwY0CQBxgpjBJvcg5Qse88/b5Zl2Ef8jL+aCI=";
      type = "gem";
    };
    version = "0.3.0";
  };
  opentelemetry-sdk = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-stlg9UxaoZ4qG6axAnlvk4a6z/4qC13dshIR7I1PxJI=";
      type = "gem";
    };
    version = "1.6.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E9JMEHFzYASmwJET7p/hY6Jdqg3v5qsnmkLKx7krG3Y=";
      type = "gem";
    };
    version = "1.10.0";
  };
  opentracing = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3rXXq+aw52Mdhm2Mte57uTUmUKUEoy9hWRMCvFELkoY=";
      type = "gem";
    };
    version = "0.5.0";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M2t1NnbWEXytkwH6x+kdq0Io90fU5xeYka06Fjxk4u0=";
      type = "gem";
    };
    version = "3.0.1";
  };
  org-ruby = {
    dependencies = [ "rubypants" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-k8vsOkRwy53KakqY3CdqZDTqnZ57wtQuozw67dXRyXQ=";
      type = "gem";
    };
    version = "0.9.12";
  };
  orm_adapter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ql0L5dVAy7RtOpPogGH07OaiX26X1qRxIr64T+WV6bk=";
      type = "gem";
    };
    version = "0.5.0";
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
  ostruct = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  pact = {
    dependencies = [
      "pact-mock_service"
      "pact-support"
      "rack-test"
      "rspec"
      "term-ansicolor"
      "thor"
      "webrick"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C92EiIhYDbfymn2HibhhuAZzcMCsDrNv/Eu3/z9fbqg=";
      type = "gem";
    };
    version = "1.64.0";
  };
  pact-mock_service = {
    dependencies = [
      "find_a_port"
      "json"
      "pact-support"
      "rack"
      "rspec"
      "thor"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtnlRUahAinXkV2lOD2usyJ2TCh2qEtOpSH1PG8fulE=";
      type = "gem";
    };
    version = "3.11.2";
  };
  pact-support = {
    dependencies = [
      "awesome_print"
      "diff-lcs"
      "expgen"
      "rainbow"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QcNDoxJPs3loS5rZ8aB2bF+hjTt41DOlLlVS2LlHWHE=";
      type = "gem";
    };
    version = "1.20.0";
  };
  paper_trail = {
    dependencies = [
      "activerecord"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6bnw+xuLWQyCMc+pMbKCupL5DgZuOTkwpeHGGuTFAZ0=";
      type = "gem";
    };
    version = "16.0.0";
  };
  parallel = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SsFR4YBrdV+04twjMsvw5U8uJLqCH/LT3Phr9txK4TA=";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JHY2QUKzB/paGx7ORPJgcoviOFipxxB46VYTGnVFPEU=";
      type = "gem";
    };
    version = "3.3.8.0";
  };
  parslet = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CNGrNyHNPxdb++6HiLLd/3H5IDjy1pvWVFTCK7n72Yo=";
      type = "gem";
    };
    version = "1.8.2";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SB2p+30vbmsaCPrxH6EDYxctxA/UeEjwlq4hIJ+AWnU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  pdf-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cl0QHiBjwB4/lB4e5Hy7l/Gt/BOVtYNy9PZfEwDzzpE=";
      type = "gem";
    };
    version = "0.10.0";
  };
  peek = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1lAerYzeRtjY7Q1Z628LpxPQpBwRosSoFEey3ON7Psw=";
      type = "gem";
    };
    version = "1.1.0";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dh7733O2ZRbwwm/L5lFdx1AMPwqhobhT/q4kVDPGT9w=";
      type = "gem";
    };
    version = "1.5.9";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iwBSKeIJ8SxYh8NMYNDrKiQZU7lHW1OphA0kV4UySB4=";
      type = "gem";
    };
    version = "6.1.0";
  };
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cDypCnywDoJj7dA9oiZmJ/Z0HSgMkQq7usB8lf+y8HM=";
      type = "gem";
    };
    version = "3.7.0";
  };
  png_quantizator = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YCPU0GQSXDp+ApKclbcyDtasDXNB+ejeDJ6mV27zEGs=";
      type = "gem";
    };
    version = "0.2.1";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prawn = {
    dependencies = [
      "matrix"
      "pdf-core"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9OIOO08wv1ua432tFetCGDFZRVOqkwsjkbD6CpnEPLY=";
      type = "gem";
    };
    version = "2.5.0";
  };
  prawn-svg = {
    dependencies = [
      "css_parser"
      "matrix"
      "prawn"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JxvdAywGZ3ey52/pcbVw4ky29IkNVlhYgQboqltuKDA=";
      type = "gem";
    };
    version = "0.37.0";
  };
  premailer = {
    dependencies = [
      "addressable"
      "css_parser"
      "htmlentities"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8Nf2uimVWclt35gqpSY/heVhfIZDfI2P//EggTstfvs=";
      type = "gem";
    };
    version = "1.23.0";
  };
  premailer-rails = {
    dependencies = [
      "actionmailer"
      "net-smtp"
      "premailer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wTgV0WG5vH99PYE5awuwphqQ+pvYmTFUi/TlN8dxBAA=";
      type = "gem";
    };
    version = "1.12.0";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uvAxxQ1s6SNZSRO+/IrIajJRv/udal6LA2h5YgVOU+M=";
      type = "gem";
    };
    version = "0.1.3";
  };
  prism = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JP+c0yMjRuaAUmWfFMmmGAIuqYk193TfRlIGq6XAbS8=";
      type = "gem";
    };
    version = "1.2.0";
  };
  proc_to_ast = {
    dependencies = [
      "coderay"
      "parser"
      "unparser"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kqc/pm4iUKg/hYn4GLB1G88ifGj4WRYgLfevhQgvhpE=";
      type = "gem";
    };
    version = "0.1.0";
  };
  prometheus-client-mmap = {
    dependencies = [
      "base64"
      "bigdecimal"
      "logger"
      "rb_sys"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RtTOZ6Bc13kQ6+mmRoIgb9HI9f0uTac3NxPhbcQ+FEQ=";
      type = "gem";
    };
    version = "1.2.10";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xP5U7+2sodNRKAtFuISa82MYRpb8rBxy4EFfm9rEM00=";
      type = "gem";
    };
    version = "0.14.2";
  };
  pry-byebug = {
    dependencies = [
      "byebug"
      "pry"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cwq7fTCbx/AARNUSo8hWcnT3ASuUSzi+zIRAQ5oc6nI=";
      type = "gem";
    };
    version = "3.11.0";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pp4o4ko0110fYLzyQRkqVCU/j374piy6HnV1CpZTWT0=";
      type = "gem";
    };
    version = "0.3.11";
  };
  pry-shell = {
    dependencies = [
      "pry"
      "tty-markdown"
      "tty-prompt"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rQJIgtKZErBxp95l6+pTiyQtLcFJjGDHwjUu+Udp8gg=";
      type = "gem";
    };
    version = "0.6.4";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [
      "danger"
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "puma" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8lwGhz6z1d5fCk68eDrMgaTM/lgMdgz+MjSXeYAYrYc=";
      type = "gem";
    };
    version = "6.6.0";
  };
  pyu-ruby-sasl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VoOmvFc421ob9c7d6vVFQF+yQbQYTdTyWH5nmn6Ul+U=";
      type = "gem";
    };
    version = "0.0.3.3";
  };
  raabro = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Pqf9Rcjke25KyQu7YvoAtGTSxRkBhrl5w2AlixdqII=";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = [
      "coverage"
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zO4QFxlpal2hLunab7Ox0gyzKZOeCJ4ORYvm6TZn8Ps=";
      type = "gem";
    };
    version = "2.2.13";
  };
  rack-accept = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZiR7VEnbZOu5OuLsSvR2S4fRrop0Y8fGiJOsE/qNTaI=";
      type = "gem";
    };
    version = "0.4.5";
  };
  rack-attack = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PKR+j2bNM7LJavU+pHVFJc2SjtP6jaEO5trQJ3eR13w=";
      type = "gem";
    };
    version = "6.7.0";
  };
  rack-cors = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QV1OFZmJF2DF3J7wNJx/7N+U98agPnWy58K1S4Kt2hs=";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-oauth2 = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xzqofFCAQ+IljwK0+xEMrLqbN9LM+ITiJIfQFKEg0aU=";
      type = "gem";
    };
    version = "2.2.1";
  };
  rack-protection = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/UFBTbq77CdK8L2x9ypIUERJ3k2Xl4LJrzjLtd//Mpk=";
      type = "gem";
    };
    version = "2.2.2";
  };
  rack-proxy = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RGpLVwAQIhRdXDunO3dfZqImDq90IMaQdIMUGQA5XIo=";
      type = "gem";
    };
    version = "0.7.7";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCEV5UILTeA2g5uYEeP3ln1zRGpVS0KqRRBq8zWFHXY=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DGH8YZBASdaRki6ku5nigATtP0OqXP1JUCTMNF8SXfs=";
      type = "gem";
    };
    version = "2.1.0";
  };
  rack-timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dXM36Xk8ypmbtzph/ip9QoCqnu+694fOO5jYYHSch9k=";
      type = "gem";
    };
    version = "0.7.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoZgSiiYn+EEO/8g2BmzYJRMoIFWQGgS3KZ0KySzwkk=";
      type = "gem";
    };
    version = "1.0.1";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ba6i7XtjkrQc4PwRRV3hGEVQJaQxtuozSnrCsQFgiAQ=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  rails-controller-testing = {
    dependencies = [
      "actionpack"
      "actionview"
      "activesupport"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dBRI21k2YHPob8llukA/iBxja3miw5pI0EhvJgcYLpQ=";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5RVxLkjfH2h6HXw4D9ewe4VY+qJkZEdNpkGDp0JvqTs=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-49L7EDOfA7gC45x/bKwoxU/UBNP2WuOcMcyp0VDFy/A=";
      type = "gem";
    };
    version = "1.6.1";
  };
  rails-i18n = {
    dependencies = [
      "i18n"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-764W4KwowPQumFVcjbEyfWmrAgWMi1NeCTPLEG3ZMco=";
      type = "gem";
    };
    version = "7.0.10";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C+FVYuLe1O/cG2ww+IS22DjJuklXPd4EIzS3UrBD4vs=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  rainbow = {
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XOS/UDe0GWwkrGKDTY2xzhdUcDkQJr2eVX1mm+6xkJc=";
      type = "gem";
    };
    version = "13.0.6";
  };
  rake-compiler-dock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5zcgopq6nBFHKM45zA2O72m6YdiOeXjFe6wXFyTNTVM=";
      type = "gem";
    };
    version = "1.9.1";
  };
  rb-fsevent = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5ALly5zAdZXD2S4UKWqZ4M+59h7RY7pKAXVa3MYrv4=";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BQBi1PMdMHzKUsP2p/S5Rt+N4l/EvTc+GlFC5BA0p8o=";
      type = "gem";
    };
    version = "0.10.1";
  };
  rb_sys = {
    dependencies = [ "rake-compiler-dock" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iZP9H0m19rOUtJ2v2nf7XGNUWGN/jv/lCMynjrwDQn0=";
      type = "gem";
    };
    version = "0.9.110";
  };
  rbs = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7XJz0BhVaERYPReFrFQZTmfuxZTWjjF9V/qQrQNVMsA=";
      type = "gem";
    };
    version = "3.6.1";
  };
  rbtrace = {
    dependencies = [
      "ffi"
      "msgpack"
      "optimist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6MumTUYr+4uhAte+Lsqsx4kkfVKsWH2AA1SdkJy5xdw=";
      type = "gem";
    };
    version = "0.5.1";
  };
  rchardet = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aTrNUlPVregaUZQGl5VfbdS7Lw0kW9p2qOI97scKUsc=";
      type = "gem";
    };
    version = "1.8.0";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MsITmuQ+2Rt8QwMv5UI9IdV3GIKcxaEeXJcQ0qpeAyk=";
      type = "gem";
    };
    version = "6.13.0";
  };
  re2 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BJgiqm96ZDUmJPYyy45Wk2GcNl0i9JCHgFQRNSoNW9g=";
      type = "gem";
    };
    version = "2.15.0";
  };
  recaptcha = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N9GJSt2ecKVNDGx/Dsvu3/v6fQdaz71MUJgY3969t+4=";
      type = "gem";
    };
    version = "5.12.3";
  };
  recursive-open-struct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o1OKclUvzrzQraZXvf8xNkGkpfvEgsCM+5plrLHJ3lo=";
      type = "gem";
    };
    version = "1.1.3";
  };
  redcarpet = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-itGInANV/0xHF0rxTt0G1i9FoybaHabooSHVm9zS6ek=";
      type = "gem";
    };
    version = "3.6.0";
  };
  RedCloth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UjGy/dkakzkVy6Mw5f0adAJed7VvV7dATHGR6/KBIpc=";
      type = "gem";
    };
    version = "4.3.4";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eYkA2GlBip/Dl3+RZXg3W0XDgkelVrYdWMumuwL30Gs=";
      type = "gem";
    };
    version = "5.4.0";
  };
  redis-actionpack = {
    dependencies = [
      "actionpack"
      "redis-rack"
      "redis-store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3AVwt4wU7GKzXBe5f6t3juWYa8VeaVv7aCZIgIhpMxE=";
      type = "gem";
    };
    version = "5.5.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Mf7kt88EEJsicyf6vqrx/FtlLPSKGGoDvGB+QHZ7rMA=";
      type = "gem";
    };
    version = "0.22.2";
  };
  redis-cluster-client = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y+bKpN64S4wgaJh1ykcLowLZXT+WORRXfySIELCg4Ks=";
      type = "gem";
    };
    version = "0.11.0";
  };
  redis-clustering = {
    dependencies = [
      "redis"
      "redis-cluster-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fOGAY3AM8w8iSMdVNZK/srYqHXYhbGWo0sjHXkJ0Vjs=";
      type = "gem";
    };
    version = "5.4.0";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6RoaorLYiLbeodSrjTnhrm+sNCYWH+udkd1cylmKIjk=";
      type = "gem";
    };
    version = "1.11.0";
  };
  redis-rack = {
    dependencies = [
      "rack-session"
      "redis-store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q7ULgq4QrU0Ryi5JAb/CuYJWza+72V+AyG/J4AFHg4A=";
      type = "gem";
    };
    version = "3.0.0";
  };
  redis-store = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7cTz4jnc0f3ZkFWE5rHmI6hGGOFENubooHxwiRAI7aQ=";
      type = "gem";
    };
    version = "1.11.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  regexp_property_values = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FiSZ3Au6HmbTNCc6BZ8gemGYHMjMadLKdDWU54htCA8=";
      type = "gem";
    };
    version = "1.0.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V2IDddy+VuwJuscZK/t0YMcWu/AFTclDReyqVDjlOdI=";
      type = "gem";
    };
    version = "0.6.0";
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
  request_store = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4bddU0ajFfRSJCpoyTfvjkiyFblFOnemwKzcopNMiMs=";
      type = "gem";
    };
    version = "1.7.0";
  };
  responders = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YT/ijkmJh/T+qjIwqmMTykvV8FY6Pag1EbDdbNj0cpI=";
      type = "gem";
    };
    version = "3.0.1";
  };
  rest-client = {
    dependencies = [
      "http-accept"
      "http-cookie"
      "mime-types"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NaZAC9sU+uKFlmGOMSd2wVj367sMytdS/0+hQr8nR+M=";
      type = "gem";
    };
    version = "2.1.0";
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
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qyKDhnZaAlmDWHPNBwVLYpOcQPYgx3wkfq+qo7I/rKQ=";
      type = "gem";
    };
    version = "3.0.0";
  };
  rexml = {
    groups = [
      "coverage"
      "danger"
      "default"
      "development"
      "omnibus"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rinku = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Pmlar58kuro69FgjtcQntYpiRYITLxhIIyDic3+fioU=";
      type = "gem";
    };
    version = "2.0.0";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQAh+Ze0NgCLDMFWmMGwcQA0cEiYZMlM7XWy82GiFQ=";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A0Iz+4pp0K0OBHaUMYTgTLlxto48IjlyTgL0KIeLaKM=";
      type = "gem";
    };
    version = "4.5.2";
  };
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I+6oi7RMfubWyrk1TQjCh/frzcYRLh/nvMLQENH/78E=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z0mJ3ILSTih3mEc4xO5WkwhiX+0qgQlg8bAtaNAwjRo=";
      type = "gem";
    };
    version = "1.2.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1JCRSsHVpaZKDhQAwdVN3SpQEyTXA7jP6D9Fgze6uZM=";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-benchmark = {
    dependencies = [
      "benchmark-malloc"
      "benchmark-perf"
      "benchmark-trend"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EBSttX7CWZokVcY4hCKfNnov/2pjp3/WjOXYBMg91s8=";
      type = "gem";
    };
    version = "0.6.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-napP8pgS5iAZPryJUuAy8DH+Fnqfba9+o9Kdwx1HyGg=";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dmta9ZuQAUdpjqD/gEVsTy5pysQ5T705L70cpWH2bFg=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IyczXe8OFmUyWpthfjr5riAnJ0HYCsVQM2MJp8Wave8=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-parameterized = {
    dependencies = [
      "rspec-parameterized-core"
      "rspec-parameterized-table_syntax"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tFbewAkZJBdawTlj4XPNuqKrPhWBpAWpSK3cNOPz9MI=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rspec-parameterized-core = {
    dependencies = [
      "parser"
      "proc_to_ast"
      "rspec"
      "unparser"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KHtJSYXnmCEWCvY6uk+R242/qaIcsgDbNLo49A4WzME=";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-parameterized-table_syntax = {
    dependencies = [
      "binding_of_caller"
      "rspec-parameterized-core"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-19+VHv+cXdNnyn1fmuSFO7ereUH51bNbujYdEScEmIw=";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4V3Mq+0hHi/ZLyEzDIGa3L6xWRwdZsWA2PLYKIVX4zE=";
      type = "gem";
    };
    version = "7.1.1";
  };
  rspec-retry = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YQG6I6OICYEa40hKzeSrSBxU2EasZtUDfMtAExpg2Fg=";
      type = "gem";
    };
    version = "0.6.2";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SId9TxW3crdTjzaTwiIl8u2kkLploFFcTnz28vF95w8=";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec_junit_formatter = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QN3mdOauTmzA/1YNolSXZ340/v0jOMxGeoly9gK2KxU=";
      type = "gem";
    };
    version = "0.6.0";
  };
  rspec_profiling = {
    dependencies = [
      "activerecord"
      "get_process_mem"
      "rails"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YZm+La6qFLrD0Q1wTbsKjfBSzwRjMsUFYDJjrqJPdZA=";
      type = "gem";
    };
    version = "0.0.9";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-09/R5ISjphnc92xqT7ppTNgzkh5P0lTREYRcJrzs/Po=";
      type = "gem";
    };
    version = "1.71.1";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T99nkv5EOpoYrLEtvIIl0NZM0WVOQf7bMOecGO27Jq4=";
      type = "gem";
    };
    version = "1.38.0";
  };
  rubocop-capybara = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XSZO/di2xwgaPUiJ3s8UUaHPquwgTYFTTiNryCWygKs=";
      type = "gem";
    };
    version = "2.21.0";
  };
  rubocop-factory_bot = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jeE81O3O5cqADyVRiBZ+zvjb/D0frp8Vc06dLnVTkqo=";
      type = "gem";
    };
    version = "2.26.1";
  };
  rubocop-graphql = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYiNQLCFd9rx50ykYjvh4wWMGpNUPVpyIIGPVholQZI=";
      type = "gem";
    };
    version = "1.5.4";
  };
  rubocop-performance = {
    dependencies = [
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XPIAAqVEJ1rWqpmrykuUXSou1xvpJcOP6DcANg7Yc04=";
      type = "gem";
    };
    version = "1.21.1";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9VYaCdav0vVDFvPw9gVzOMpVtsJKJbpqk40+0P3thK0=";
      type = "gem";
    };
    version = "2.26.2";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xqjin7GwDSJ8Mt8VnpL167ng/3NOUpVfsTr/XHSXfg8=";
      type = "gem";
    };
    version = "3.0.5";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iIES6D+dfvetI5fp1poLlhSkuuJPByw5mAShgPgMTEY=";
      type = "gem";
    };
    version = "2.30.0";
  };
  ruby-fogbugz = {
    dependencies = [
      "crack"
      "multipart-post"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XgTN5HRkj0mKcc8eGnq0LGa5U4YvviJPeT7Ap6HV9lc=";
      type = "gem";
    };
    version = "0.3.0";
  };
  ruby-lsp = {
    dependencies = [
      "language_server-protocol"
      "prism"
      "rbs"
      "sorbet-runtime"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BpVhNQAXFridCDhXFMCV4BprNWNFLkomV4GJnSb7J2k=";
      type = "gem";
    };
    version = "0.23.20";
  };
  ruby-lsp-rails = {
    dependencies = [ "ruby-lsp" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZwrtRm5UtWMuSQe43tuR2LFEkXxCUT4BPWVq8XW/jHY=";
      type = "gem";
    };
    version = "0.3.31";
  };
  ruby-lsp-rspec = {
    dependencies = [ "ruby-lsp" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0qkVUCNS6XIs09Z+HqxsUXmD7E/lgMbelfVvYYRBaNM=";
      type = "gem";
    };
    version = "0.1.23";
  };
  ruby-magic = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eyE4h3t9I6/4EslVZOumRzt0uBXvhb6w63kucporYQE=";
      type = "gem";
    };
    version = "0.6.0";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zBJ9s4ZtxBT/zL+SkookHlhbOqK3WKVWPnSm7g9X1Qo=";
      type = "gem";
    };
    version = "1.11.0";
  };
  ruby-saml = {
    dependencies = [
      "nokogiri"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3jQqVZJf1c5hFNCAJlHDJEKMD+wm5/5Svzp8+lTb+m0=";
      type = "gem";
    };
    version = "1.18.0";
  };
  ruby-statistics = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fWl6vV3E5hQdIey0FlSCgHVk8Ru+FUzxxgomd7UH8qk=";
      type = "gem";
    };
    version = "4.1.0";
  };
  ruby2_keywords = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyntlm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WzIUVtujEwNR90Ufhmnxr6g6DSb9Y83sKFt7iOZnEC0=";
      type = "gem";
    };
    version = "0.6.3";
  };
  rubypants = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8H446seTZVoDI/6RlGCBBSNBueaYBwJvzxAjRlie7e4=";
      type = "gem";
    };
    version = "0.2.0";
  };
  rubyzip = {
    groups = [
      "default"
      "development"
      "omnibus"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  rugged = {
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NiYx3o3G8QdCQvIeARSKxwt/6M2xf4Xu6R1OqDRXywQ=";
      type = "gem";
    };
    version = "1.6.3";
  };
  safe_yaml = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JIGTmS7xcwoMnsV5mZ7yJWorOjKpvZ1wih4SVEpInsI=";
      type = "gem";
    };
    version = "1.0.4";
  };
  safety_net_attestation = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lr4tdOftJkU6UYlJE0Sb6g4HL0RJACFUWsLRw4sHGM4=";
      type = "gem";
    };
    version = "0.4.0";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SMTrjpK7FpkFa2AAmGrFD8nfgvRYqUGr8sTWdZvM1c8=";
      type = "gem";
    };
    version = "6.0.2";
  };
  sass-embedded = {
    dependencies = [
      "google-protobuf"
      "rake"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oqatxM5pXs54D0A4jSB945blCR3dKHZ0QMeQekUBvto=";
      type = "gem";
    };
    version = "1.77.5";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+jpy1ipFJVF7GIV923iSaqs0JN4BKb5ncqjiuiQOeso=";
      type = "gem";
    };
    version = "0.9.2";
  };
  sd_notify = {
    groups = [ "puma" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y8esbKp87dJrMKcrXutvNgUNwHUt8mNFLqJPtaStMTE=";
      type = "gem";
    };
    version = "0.1.1";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "monorepo"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  seed-fu = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bZAtEtwbiKFtSHUGuqzJOzqS42cf3WAxENFgDTX79Hg=";
      type = "gem";
    };
    version = "2.3.9";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-INvfJ7WGvurJ4nkaIjErQU0KMBkrbOFEd599/eiuiv4=";
      type = "gem";
    };
    version = "4.32.0";
  };
  semver_dialects = {
    dependencies = [
      "deb_version"
      "pastel"
      "thor"
      "tty-command"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YRCwUmb3yM53lIadTZ3T4Vw+WHjrH/5fDOoABgFB3R4=";
      type = "gem";
    };
    version = "3.7.0";
  };
  sentry-rails = {
    dependencies = [
      "railties"
      "sentry-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jSy8PIXjQ8HogtfIWV1BDgw6+jsAX1FDAiW5OOEo3sQ=";
      type = "gem";
    };
    version = "5.23.0";
  };
  sentry-ruby = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jouy+aVqJnpQ/LqUfyrhMbZUL0X8O7V2TCwlumjzhcw=";
      type = "gem";
    };
    version = "5.23.0";
  };
  sentry-sidekiq = {
    dependencies = [
      "sentry-ruby"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NNxkE6JXc+GFrLpgWw7U3Oxe3z6OViRHt7RO1kNdHBg=";
      type = "gem";
    };
    version = "5.23.0";
  };
  shellany = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DhJ6kTJph2bX51LoLNrIJQtq29CebAp/u7b2GWT+3uc=";
      type = "gem";
    };
    version = "0.0.1";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kFW7f0uzQhJfuGCAl5iFXGMOBe9edYN7MWi45u4WCLA=";
      type = "gem";
    };
    version = "6.4.0";
  };
  sidekiq = {
    dependencies = [
      "base64"
      "connection_pool"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EQhxLh3viQArKONUXVrhXUpX/9TSwl2XuxNgmIgmtac=";
      type = "gem";
    };
    version = "7.3.9";
  };
  sidekiq-cron = {
    dependencies = [
      "fugit"
      "globalid"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZmMICkVAiL2IdzoNo66R5VS4ouiwbPxilSmoP9GjCWw=";
      type = "gem";
    };
    version = "1.12.0";
  };
  sigdump = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u3BsHM5wRYsoXSw6VxIegBzLefaL5/c3dpLrQLVDckI=";
      type = "gem";
    };
    version = "0.2.5";
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
      hash = "sha256-Zs2owu3C3eJQkLeS5+b8lZjDwr3WT/rNifH/48uc6js=";
      type = "gem";
    };
    version = "0.18.0";
  };
  simple_po_parser = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EiaH1E095Rag5p4vODpBgPUBXoxe1afyJY8rN29ky/M=";
      type = "gem";
    };
    version = "1.1.6";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [
      "coverage"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/iYix4NP8juYBmuwqFQoSycppWmsZZ+CYh/CLvNiE6U=";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-cobertura = {
    dependencies = [
      "rexml"
      "simplecov"
    ];
    groups = [
      "coverage"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LGUy403y44o3nXLO+aBcOxbGTOkFZr7rxoh4AcStPwI=";
      type = "gem";
    };
    version = "2.1.0";
  };
  simplecov-html = {
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SxqtMyWf+6iynGh2wS23DldQy534KUhuTG5dpPoKoHs=";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov-lcov = {
    groups = [
      "coverage"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ARXzHLfvXsQzT12TgsZ/1D3i5ScOIbZb/Gk9qC3XE8E=";
      type = "gem";
    };
    version = "0.8.0";
  };
  simplecov_json_formatter = {
    groups = [
      "coverage"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpQY++jeFxOsKy1hKqPapW0xaXXTByRDmfpIOMYBtCg=";
      type = "gem";
    };
    version = "0.1.4";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CM6W8D+hYFKGviJlG6D8nAstYnLJsnomC8iL4FsNLCk=";
      type = "gem";
    };
    version = "0.2.3";
  };
  singleton = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g+obyl9Ko00AMFq4QqeGLqWooRxz02LLUjedlOlhV3g=";
      type = "gem";
    };
    version = "0.3.0";
  };
  sixarm_ruby_unaccent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AEOmB3vfLEsDBAFSZ2oH+L93FE+bAHsZYO5clNE6Q4Q=";
      type = "gem";
    };
    version = "1.2.0";
  };
  slack-messenger = {
    dependencies = [ "re2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WFgeWH3ry7dpM2zH6+TrauQRlH/M80fpZ6F6yYE+Ztg=";
      type = "gem";
    };
    version = "2.3.6";
  };
  snaky_hash = {
    dependencies = [
      "hashie"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/osuOej/aTIPeBKvc+oGQBV54p/xc0pwCVZzkWAGh94=";
      type = "gem";
    };
    version = "2.0.0";
  };
  snowplow-tracker = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-e6b08UQ6gphF/SjmPtpy2dPSR/SFMQ3czK67xStzSjg=";
      type = "gem";
    };
    version = "0.8.0";
  };
  solargraph = {
    dependencies = [
      "backport"
      "benchmark"
      "diff-lcs"
      "jaro_winkler"
      "kramdown"
      "kramdown-parser-gfm"
      "logger"
      "observer"
      "ostruct"
      "parser"
      "rbs"
      "reverse_markdown"
      "rubocop"
      "thor"
      "tilt"
      "yard"
      "yard-solargraph"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hCcFzFEaCF6WcxTei9LdibAPkCOLVYLmZf+jnvvYgOA=";
      type = "gem";
    };
    version = "0.54.4";
  };
  solargraph-rspec = {
    dependencies = [ "solargraph" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DfyRJPF7I+lcMKy4LB95nIZUCKVrFwmbLW17I6dr+s4=";
      type = "gem";
    };
    version = "0.5.1";
  };
  sorbet-runtime = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZLZREvLmpTIzEMqawNfZpr5jqt5aYqYiX+BmBC/0/bY=";
      type = "gem";
    };
    version = "0.5.11647";
  };
  spamcheck = {
    dependencies = [ "grpc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oim6nfzVlUPYgFTTjGV/eeCmz0TXY98IrUdoCr7VDsc=";
      type = "gem";
    };
    version = "1.3.3";
  };
  spring = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CqrzvM446FKCdYVIgdGSJmDXbL0ZqaOvSkGdlbf+cSI=";
      type = "gem";
    };
    version = "4.3.0";
  };
  spring-commands-rspec = {
    dependencies = [ "spring" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YgLlT6R2dFLjZBRhqDNHZFr0eL9F3dzKlze0OvDdGiw=";
      type = "gem";
    };
    version = "1.0.4";
  };
  sprite-factory = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VYZSShrsADJB8avGhSthQz6Yirpe4rVfkGOHv0mwG6I=";
      type = "gem";
    };
    version = "1.7.1";
  };
  sprockets = {
    dependencies = [
      "concurrent-ruby"
      "rack"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XqHX+s0JIDwaoZav1heCCM0lq9vMKpl4gQovB1ThUqA=";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qeiObOn4yRLTSapUAVCRZexCMmuvnpQqhd5LdtvEEZ4=";
      type = "gem";
    };
    version = "3.5.2";
  };
  ssh_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7HwelaOuvu5BIUeZj0wUe0sF2m7Qqv2mCD+USTGOqsA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  ssrf_filter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A/SfVIN+QH1D7pPsczqKlNwbz4GFZHrGFgbmOq7aoNs=";
      type = "gem";
    };
    version = "1.0.8";
  };
  stackprof = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r/bShlbIUudM9jLMIEb4SQM9wd7f/ny4wDDWG1dF6Aw=";
      type = "gem";
    };
    version = "0.2.27";
  };
  state_machines = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I+YknTdKkgtSjcyt5ANRi0q72DhBo+LJ7xPm8aAJsQI=";
      type = "gem";
    };
    version = "0.5.0";
  };
  state_machines-activemodel = {
    dependencies = [
      "activemodel"
      "state_machines"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6TLasZDUvgRPtfnKsBo+oLCSxfET1GdsbAoNSb9zjSw=";
      type = "gem";
    };
    version = "0.8.0";
  };
  state_machines-activerecord = {
    dependencies = [
      "activerecord"
      "state_machines-activemodel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-By+3AbirA94GCCl/bFXcNO0JblVvqPd+VW88RhxxqrY=";
      type = "gem";
    };
    version = "0.8.0";
  };
  state_machines-rspec = {
    dependencies = [
      "activesupport"
      "rspec"
      "state_machines"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K6V6Rd9X0Ml/eRRuLg9l9Rm1LmXhgoBe95y3Ox/lwL0=";
      type = "gem";
    };
    version = "0.6.0";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3i3yyQqMV+0/KYaglXWLsQ49Y2iuQvmYEhUat5FB/o=";
      type = "gem";
    };
    version = "3.1.7";
  };
  strings = {
    dependencies = [
      "strings-ansi"
      "unicode-display_width"
      "unicode_utils"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kzKTs8lc+FuB60Szz2c+MIdmG6c5u63+rfRCCDFY1vs=";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kCYtdg6kqUzCro1YIFJ3o0NAnCiMvnwpQWsYJr1RHIg=";
      type = "gem";
    };
    version = "0.2.0";
  };
  swd = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TNvipCRsGfCT/OIuln7D691GV9N2c2cuYhvwx+t3BlU=";
      type = "gem";
    };
    version = "2.0.3";
  };
  sync = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZoNWzAfFmsftns80/sOSmDHxecB62x8+HDt6FgmmOP0=";
      type = "gem";
    };
    version = "0.5.0";
  };
  sys-filesystem = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OQkZ3omCKtbTuj2vaU1yC+nYPtlc33rfVNRXPJixdCE=";
      type = "gem";
    };
    version = "1.4.3";
  };
  sysexits = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WYJBxK5XuqQDwSUYLf3MDRrEwPtgbdR/vtV+Sq95VmI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  table_print = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q2ZkKB+TOHuIIzV5XhbP7rg5rQx4X/f5EQ/A8Xxotcs=";
      type = "gem";
    };
    version = "1.5.7";
  };
  tanuki_emoji = {
    dependencies = [ "i18n" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3uIYKlytb4jtkc1OOQiL0qjzE+JPg/9dS1sP7PKfbZM=";
      type = "gem";
    };
    version = "0.13.0";
  };
  telesign = {
    dependencies = [ "net-http-persistent" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3Mbpbqe8tNoeKueGv+ek1nCktflK6V383ed9VHxUTEI=";
      type = "gem";
    };
    version = "2.2.4";
  };
  telesignenterprise = {
    dependencies = [ "telesign" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8UegMmOowv4KDbGnqUVKbuN9noq9WOrKMFvdgIH58bM=";
      type = "gem";
    };
    version = "2.2.2";
  };
  temple = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wSBxIUNGxgbb0hm0EXJ20EqfLCDWXmamayxOwY78Hxg=";
      type = "gem";
    };
    version = "0.8.2";
  };
  term-ansicolor = {
    dependencies = [ "tins" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kjOf/sd8S93HhqKThckWAd1S/Gj+2iNgm7oEkSKbBfc=";
      type = "gem";
    };
    version = "1.7.1";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+VG2r18+ACA/spCmaeCoXF3VsFGzsCM5LM/We6WrrpE=";
      type = "gem";
    };
    version = "3.0.2";
  };
  terser = {
    dependencies = [ "execjs" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gMLgvH4ttOEuhSllj54IIOE9aFrmfXRb+YHyaXQ7so4=";
      type = "gem";
    };
    version = "1.0.2";
  };
  test-prof = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GllRPtnTOh9coXwLidpOcPYKkcg+xi6ahz27mRQTU+8=";
      type = "gem";
    };
    version = "1.4.4";
  };
  test_file_finder = {
    dependencies = [ "faraday" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g/sFiKBrJ4S1GJKRC5v9BmCfjTHy2FGpjZdvZE0XcZk=";
      type = "gem";
    };
    version = "0.3.1";
  };
  text = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L7u8gsHOecQZWxMBiofLsA12K9o5JBuzzcMnknWd0/Q=";
      type = "gem";
    };
    version = "1.3.1";
  };
  thor = {
    groups = [
      "default"
      "development"
      "omnibus"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+n40cdT2onE449nJsNTarJw9c4OSdmeug+mrQq50Ae8=";
      type = "gem";
    };
    version = "1.3.1";
  };
  thread_safe = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ntcHKCG1HFfo1rcBGo4oLiWu6jpAZeqzJuQ/ZvBjsFo=";
      type = "gem";
    };
    version = "0.3.6";
  };
  thrift = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0CMobqieMERMnxwo3XYQf4fYqvhf4XQtodjNO1QX3M4=";
      type = "gem";
    };
    version = "0.16.0";
  };
  tilt = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-exgPxHLL3rGGyF0xwPLR5hosDXfh2f0MooSCqdly1qA=";
      type = "gem";
    };
    version = "2.0.11";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  timfel-krb5-auth = {
    groups = [
      "default"
      "kerberos"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qziMnXR/o82VuvLMHAMlPjctjGgK3MVDZw9PCZhUu4A=";
      type = "gem";
    };
    version = "0.8.3";
  };
  tins = {
    dependencies = [ "sync" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UcSjR8JcYw0xDLwsBA/7hOJmyCJ/Kt6IHxEw7k+fvs8=";
      type = "gem";
    };
    version = "1.31.1";
  };
  toml-rb = {
    dependencies = [ "citrus" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oeLFSsPMnUmGEAT3XwZIs2IqwDp2q+EFNYwxVTIn2aY=";
      type = "gem";
    };
    version = "2.2.0";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aGZr9T+nC6aGpIp0Nc5+CG9SJ8WMTJk72XkvR2DypQM=";
      type = "gem";
    };
    version = "1.3.0";
  };
  tpm-key_attestation = {
    dependencies = [
      "bindata"
      "openssl"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4TPYDPJP7w56ffrQD9au/wH8eYdfv8Zs2FN7vWIrHm0=";
      type = "gem";
    };
    version = "0.12.0";
  };
  traces = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0lR4NLcki7jI9PZTLGubqA744tYGjOFueHNXXXuALYE=";
      type = "gem";
    };
    version = "0.15.2";
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
  train-core = {
    dependencies = [
      "addressable"
      "ffi"
      "json"
      "mixlib-shellout"
      "net-scp"
      "net-ssh"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hJPaAgFfvpsRhA0iuoee8YoKomM8sMBOrD8H3ZuHIjs=";
      type = "gem";
    };
    version = "3.10.8";
  };
  truncato = {
    dependencies = [
      "htmlentities"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NGIZQ8Bn64kjidNW0TEoIrgbV06NfewrYZVf7w6R44A=";
      type = "gem";
    };
    version = "0.7.13";
  };
  ttfunk = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-p8vH5InMRul53eBNNLW55PXI8e5fxrGnvjm4KZGdIMo=";
      type = "gem";
    };
    version = "1.8.0";
  };
  tty-color = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b5w3yjpOI2f7Lm0JcidiZH1vRVwRHwW1nzVzDuskMyo=";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-command = {
    dependencies = [ "pastel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DGxHH8uTLVVRhzTrTi4H6e/dKRhxPMObtzk7qGJHEZI=";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-cursor = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-markdown = {
    dependencies = [
      "kramdown"
      "pastel"
      "rouge"
      "strings"
      "tty-color"
      "tty-screen"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HtgduXAo0Aa6geLP2f4KBLDrKGUK0NQIbtblYn9KxRE=";
      type = "gem";
    };
    version = "0.7.2";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/NvOkFI4mT8n7s/fZ1l6Y2vIOdkhkvag7vIrgWZEnsg=";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xilyyYXAsVZvDlZ0O2p4gvl509wy/0ke1JCgdviZwrE=";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZQhlfDjzK9ymSICr4gHOI32AyUFG4fm5Ecujx4I2WaI=";
      type = "gem";
    };
    version = "0.8.1";
  };
  typhoeus = {
    dependencies = [ "ethon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HBfbg2S9RaswLcYeRgFzw+aYNYlr6Io98HwgbVxV73w=";
      type = "gem";
    };
    version = "1.4.1";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
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
  undercover = {
    dependencies = [
      "base64"
      "bigdecimal"
      "imagen"
      "rainbow"
      "rugged"
    ];
    groups = [
      "coverage"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PDT88Sm1KkmTBlxSYSpl5eBed/DKw/T484gRT7Ep7Bo=";
      type = "gem";
    };
    version = "0.6.4";
  };
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SZlRelMfKpVXUPiDGUGJH2FYSY7Jtsscgc6JOI5jAi4=";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kLliPuNZzEh4RhxdLqt9PTzlgBpoCp56yDuAQMW3Qvo=";
      type = "gem";
    };
    version = "0.0.8.2";
  };
  unicode-display_width = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ahAgXRoZynkMTlMGS6k/CdnrI0v2vRNdnetgAcIUKL4=";
      type = "gem";
    };
    version = "2.4.2";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LCxO9/NT5YCUlxJihaULIwVsxuYbZEM3ZKNe/2w2Uyo=";
      type = "gem";
    };
    version = "4.0.4";
  };
  unicode_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uSLQzyMTtrcTatpmRc5xVP/IZBjKB9U7BY7+nrcvKkA=";
      type = "gem";
    };
    version = "1.4.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mbOe5KCGTjtJ83W15YA+sm017W6xcZyWQHVzqHvE27U=";
      type = "gem";
    };
    version = "1.16.0";
  };
  unleash = {
    dependencies = [ "murmurhash3" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D25WSY3pIN5moBvO/7k5M2k63mRruFP8cOsWvRAmuTs=";
      type = "gem";
    };
    version = "3.2.2";
  };
  unparser = {
    dependencies = [
      "diff-lcs"
      "parser"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rkLnPt+ic3ZuZsFmNo+3XKWXLNjsUMU2JT4PYpmp3sg=";
      type = "gem";
    };
    version = "0.6.7";
  };
  uri = {
    groups = [
      "danger"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pVcZbmUgEbz/CzbSn55Cf+/PYMw1wKuMzgh2imKH5Fc=";
      type = "gem";
    };
    version = "0.13.2";
  };
  valid_email = {
    dependencies = [
      "activemodel"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uBRStRtkxL62eRP2jbUsIOy01z1FUS9bKCq0o/RBZXA=";
      type = "gem";
    };
    version = "0.1.3";
  };
  validate_url = {
    dependencies = [
      "activemodel"
      "public_suffix"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cv4WTAcT1jqZcL1nAL6pSLq7+9zsOS8jQrZwQEL1dFE=";
      type = "gem";
    };
    version = "1.0.15";
  };
  validates_hostname = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6sQBeMwLT3J9+cxqXLW8JVBxitjZuzco35q6Y1S92hk=";
      type = "gem";
    };
    version = "1.0.13";
  };
  version_gem = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qWR2fsvjZVG5/y5ZCZVIwnVp8vf5S9sJ9gnXY5Oo4Ag=";
      type = "gem";
    };
    version = "1.1.8";
  };
  version_sorter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IUfyoaOAT7uPYNJot9fB7HF+bdcn/+LBZbTgXoLv4do=";
      type = "gem";
    };
    version = "2.3.0";
  };
  view_component = {
    dependencies = [
      "activesupport"
      "concurrent-ruby"
      "method_source"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PC/tS544vwdPo9QspV7tuyzAcODzwx18E6ULDbUwiSs=";
      type = "gem";
    };
    version = "3.23.2";
  };
  virtus = {
    dependencies = [
      "axiom-types"
      "coercible"
      "descendants_tracker"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iEHa5Ot/zAlzILpepRa/GDnl0FbGHuJxOKpL3dbj0cI=";
      type = "gem";
    };
    version = "2.0.0";
  };
  vite_rails = {
    dependencies = [
      "railties"
      "vite_ruby"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GVxEZ3vAXB+U56afEmTknUutJymrBlOO6FjCli9btQA=";
      type = "gem";
    };
    version = "3.0.19";
  };
  vite_ruby = {
    dependencies = [
      "dry-cli"
      "logger"
      "mutex_m"
      "rack-proxy"
      "zeitwerk"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4Qp8hRtZDMyrV5BLyWwusHjtbiJWCneNsdzvo4GKSXI=";
      type = "gem";
    };
    version = "3.9.2";
  };
  vmstat = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VYfLQwpU2/xKXCndAb1qQDGy/0wdOHUE10/yRvOzkQQ=";
      type = "gem";
    };
    version = "2.3.1";
  };
  warden = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RmhPiF01pp27iD3qv4WiIsjkJ6lXgEcZ4UMAXfeh79A=";
      type = "gem";
    };
    version = "1.2.9";
  };
  warning = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxLEn+oMBnV3eO79zHdx5P2ZMIkB49VcUE2Hr91xjFM=";
      type = "gem";
    };
    version = "1.5.0";
  };
  webauthn = {
    dependencies = [
      "android_key_attestation"
      "awrence"
      "bindata"
      "cbor"
      "cose"
      "openssl"
      "safety_net_attestation"
      "tpm-key_attestation"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P3fUIsKopLMeVs9C+DQUvQZuBQbpiWk24XMCYtxKIOY=";
      type = "gem";
    };
    version = "3.0.0";
  };
  webfinger = {
    dependencies = [
      "activesupport"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VnpSved/s4ymtn5V23VfmIdm7EZRwdJJFqZapwVAaVw=";
      type = "gem";
    };
    version = "2.1.3";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q51dk1O8vmMiyD4cYKcQOYjvx7Z81y/7kBJinD05YyM=";
      type = "gem";
    };
    version = "3.25.1";
  };
  webrick = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LMGkp5tuY2N7MmtCc+Rq3N33hxyqXcVxHyykBhpin6g=";
      type = "gem";
    };
    version = "1.2.10";
  };
  websocket-driver = {
    dependencies = [ "websocket-extensions" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9pQAvnvBl4eXJq2Ob1hpphgjFHNy/Ykog2pTwsdB0Ns=";
      type = "gem";
    };
    version = "0.7.6";
  };
  websocket-extensions = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
  wikicloth = {
    dependencies = [
      "builder"
      "expression_parser"
      "rinku"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-esipygqUjPRyhR5SGvxsKmsEqPke8dgkumph/71g5so=";
      type = "gem";
    };
    version = "0.8.1";
  };
  wisper = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zhe8XDoWbyQaLmYThIsCXIFG/OLe+6UFkgwdHz+I+uY=";
      type = "gem";
    };
    version = "2.0.1";
  };
  with_env = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ULPk8KbNqPkNimvYemJh9sOBQpq6+xYcTGmtSgzQtuQ=";
      type = "gem";
    };
    version = "1.1.0";
  };
  wmi-lite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EW71u0cNvmD1jC25BHrzBkwWJF1lYsZGvA2Qh34n3do=";
      type = "gem";
    };
    version = "1.0.7";
  };
  xml-simple = {
    dependencies = [ "rexml" ];
    groups = [
      "default"
      "development"
      "omnibus"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0hEx5RnIbxpbwrbS1X1G5pmOR/GO0kmyXK2GQz29aV0=";
      type = "gem";
    };
    version = "1.1.9";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bf2nnZG7O5SblH7MWRnwQu8vOZuQQBPrPvbSDdOkCC4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJdNnBGuB7CjttJu/qhAcmmwLkE4EY++PvDS7Jck0dI=";
      type = "gem";
    };
    version = "1.4.3";
  };
  yard = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pukQOZ545hP4C6mt2bp8OUsak18IPMy++CkDo9KiaZI=";
      type = "gem";
    };
    version = "0.9.37";
  };
  yard-solargraph = {
    dependencies = [ "yard" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oZpGGclCGBphj7lFiXCp0lNM9/2mn8Q5SWKaeUilkw4=";
      type = "gem";
    };
    version = "0.1.0";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YXZ6YVhIDfKQ0NKj/YYNi6Oii6ETg3Zo7pS2V3FqFAk=";
      type = "gem";
    };
    version = "2.6.7";
  };
}
