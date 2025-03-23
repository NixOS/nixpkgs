{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jfki5ikfr8ln5cdgv4iv1643kax0bjpp29jh78chzy713274jh3";
      type = "gem";
    };
    version = "1.1.1";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gn09cafg2n6gdc3ja80r3xjllly05r0m7x3w3b3rywir6k6ai4f";
      type = "gem";
    };
    version = "1.436.0";
  };
  aws-sdk-autoscaling = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0br6hfi2i5rri8ivamkmnx00p640s24pqmp8s67sm5asvdfzx4vr";
      type = "gem";
    };
    version = "1.59.0";
  };
  aws-sdk-cloudwatch = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xga00dn925rfgz4p2zf734aaik00dqb9psll27lg5626jd6xr0c";
      type = "gem";
    };
    version = "1.50.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1774xyfqf307qvh5npvf01948ayrviaadq576r4jxin6xvlg8j9z";
      type = "gem";
    };
    version = "3.113.0";
  };
  aws-sdk-dynamodb = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dfsmkzv9cziykzc56g9pwxmbdqjpykxka3fq07b6iarzh38j1i3";
      type = "gem";
    };
    version = "1.60.0";
  };
  aws-sdk-ec2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c7qqly2f94db3643xwjj9mcb34vilx11awbv40v2f8z7xisvvz3";
      type = "gem";
    };
    version = "1.230.0";
  };
  aws-sdk-efs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kmpz86sxkm6nzcf80nd65902fy29hz8lvx1kjwl5idx07ls8pnd";
      type = "gem";
    };
    version = "1.39.0";
  };
  aws-sdk-elasticache = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05kn2k437rnsf9nkwc1x5i2klrasjgyk1pj89f2gb0za86swjcza";
      type = "gem";
    };
    version = "1.54.0";
  };
  aws-sdk-elasticloadbalancing = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j3px8dn2yxsnmy010kfkwa1a2flbdxachmly20f436ysi3ql3v3";
      type = "gem";
    };
    version = "1.31.0";
  };
  aws-sdk-elasticloadbalancingv2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16hknbqv5s1im04dch9kdbc79x072613imdih62w48mvsf12c1mm";
      type = "gem";
    };
    version = "1.61.0";
  };
  aws-sdk-iam = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x2768blsy8lpib9pi2f2d67flabar3bq6chmbj07iqzpwvpz569";
      type = "gem";
    };
    version = "1.51.0";
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
      sha256 = "01pd0f4srsa65zl4zq4014p9j5yrr2yy9h9ab17g3w9d0qqm2vsh";
      type = "gem";
    };
    version = "1.43.0";
  };
  aws-sdk-rds = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hwxgcka6bmzdn5pazss0fv8xgbbgas4h2cwpzwhkjkwhh23dx6a";
      type = "gem";
    };
    version = "1.117.0";
  };
  aws-sdk-redshift = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sp186v00lj517hia6rsn28ph8rqknz9r79vbkbyh5fgrbh2j6bd";
      type = "gem";
    };
    version = "1.58.0";
  };
  aws-sdk-route53 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p9g0scw9c6qancdwvaw3kkj3pywchy2vl3qz2rqpjncqvj04pn5";
      type = "gem";
    };
    version = "1.48.0";
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
      sha256 = "0iy2f9z43pc6fgwmga2cz8nf9gy2pwcw4jib141vp8z8dhylqj94";
      type = "gem";
    };
    version = "1.93.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pmxi871r2nkl6by89vsy05ahk8dr6hmkny56fycrby6r9kri9q4";
      type = "gem";
    };
    version = "1.39.0";
  };
  aws-sdk-sqs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01m2l8y4q4fixjvl70w5bi1ihmmx2y4krms9kkjwd3ch21y14hif";
      type = "gem";
    };
    version = "1.38.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9zhmi3mpfzkkpg7yw7s9r1dwk157kh9875j3c7gh6cy95lmmaw";
      type = "gem";
    };
    version = "1.2.3";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1raim9ddjh672m32psaa9niw67ywzjbxbdb8iijx3wv9k5b0pk2x";
      type = "gem";
    };
    version = "1.12.2";
  };
  terraforming = {
    dependencies = [
      "aws-sdk-autoscaling"
      "aws-sdk-cloudwatch"
      "aws-sdk-dynamodb"
      "aws-sdk-ec2"
      "aws-sdk-efs"
      "aws-sdk-elasticache"
      "aws-sdk-elasticloadbalancing"
      "aws-sdk-elasticloadbalancingv2"
      "aws-sdk-iam"
      "aws-sdk-kms"
      "aws-sdk-rds"
      "aws-sdk-redshift"
      "aws-sdk-route53"
      "aws-sdk-s3"
      "aws-sdk-sns"
      "aws-sdk-sqs"
      "multi_json"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03fyhqx6bxpbn26pbcz748gz7rh7q3r9r0jimq7vj07fl454fmwh";
      type = "gem";
    };
    version = "0.18.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
}
