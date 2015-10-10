{
  "activesupport" = {
    version = "3.2.22";
    source = {
      type = "gem";
      sha256 = "1rs7x6gdvmj723ahqmrkla4d3sdlf0fbiwjvfpyha6za73qakhmj";
    };
    dependencies = [
      "i18n"
      "multi_json"
    ];
  };
  "blockenspiel" = {
    version = "0.4.5";
    source = {
      type = "gem";
      sha256 = "0gx5dbjrl6p3qxphczy0iv04alny38m6dfqbhkxpwbmzkz41y7rj";
    };
  };
  "i18n" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
    };
  };
  "json" = {
    version = "1.7.7";
    source = {
      type = "gem";
      sha256 = "1v5pn3g9ignbgrfl72dbf7bzvxsm90ybp24fa3bm9cv5cpa2ww7x";
    };
  };
  "multi_json" = {
    version = "1.11.2";
    source = {
      type = "gem";
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
    };
  };
  "parseconfig" = {
    version = "1.0.6";
    source = {
      type = "gem";
      sha256 = "1ghbi40pck7aa3x1493k0djiwl6wlsadvfyj4yvw1f6m18arvn3x";
    };
  };
  "rack" = {
    version = "1.6.4";
    source = {
      type = "gem";
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
    };
  };
  "rack-flash3" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "0rim9afrns6s8zc4apiymncysyvijpdg18k57kdpz66p55jf4mqz";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "rinku" = {
    version = "1.7.3";
    source = {
      type = "gem";
      sha256 = "1jh6nys332brph55i6x6cil6swm086kxjw34wq131nl6mwryqp7b";
    };
  };
  "simple-navigation" = {
    version = "4.0.3";
    source = {
      type = "gem";
      sha256 = "17hxg004kdhnkfczz3rify9748glicpd83nrhm6kxx143ncvslgv";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "sinatra" = {
    version = "1.4.6";
    source = {
      type = "gem";
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "sinatra-simple-navigation" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "0shw1z8nbdrihjd6ycpsr5d8f53hc1vr6gjzmf8gfc36ncfvbdb2";
    };
    dependencies = [
      "simple-navigation"
      "sinatra"
    ];
  };
  "taskwarrior-web" = {
    version = "1.1.11";
    source = {
      type = "gem";
      sha256 = "1pk9ls5735p01zrlgk2kcb0xhpickmnqmniv8g776vg7ffsl65mj";
    };
    dependencies = [
      "activesupport"
      "json"
      "parseconfig"
      "rack-flash3"
      "rinku"
      "sinatra"
      "sinatra-simple-navigation"
      "vegas"
      "versionomy"
    ];
  };
  "tilt" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "1qc1k2r6whnb006m10751dyz3168cq72vj8mgp5m2hpys8n6xp3k";
    };
  };
  "vegas" = {
    version = "0.1.11";
    source = {
      type = "gem";
      sha256 = "0kzv0v1zb8vvm188q4pqwahb6468bmiamn6wpsbiq6r5i69s1bs5";
    };
    dependencies = [
      "rack"
    ];
  };
  "versionomy" = {
    version = "0.4.4";
    source = {
      type = "gem";
      sha256 = "0ikp6br7d8zrba63270hxh427cc3s3pa5hrs4ayjgp3ipx8mfq2f";
    };
    dependencies = [
      "blockenspiel"
    ];
  };
}