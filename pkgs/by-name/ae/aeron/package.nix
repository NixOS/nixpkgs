{
  lib,
  stdenv,
  fetchMavenArtifact,
  jdk11,
  makeWrapper,
}:

let
  pname = "aeron";
  version = "1.49.0";
  groupId = "io.aeron";

  aeronAll_1_49_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.49.0";
    hash = "sha256-n3qoLs+iYzrb95skr29DrpQPHsWBZL6IygnayNJ1s6Q=";
  };

  aeronSamples_1_49_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.49.0";
    artifactId = "aeron-samples";
    hash = "sha256-ePhAUBebeZP5exfBOGpUTTntAeZIdsolPuyhpbv0GVo=";
  };

  aeronAll_1_48_6 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.6";
    hash = "sha256-IWURDka8Qudit1nN/aHi4DHOAxpj++/1iSAbI5QNaBg=";
  };

  aeronSamples_1_48_6 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.6";
    artifactId = "aeron-samples";
    hash = "sha256-L5DFzZSfBRSGZOxDkfX1CTYyRNawd8tJLQaLZzYQTew=";
  };

  aeronAll_1_48_5 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.5";
    hash = "sha256-yPLTh8bYBRwG0y5Tc+Z9TSSoYZSe55RQOb22LbBL804=";
  };

  aeronSamples_1_48_5 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.5";
    artifactId = "aeron-samples";
    hash = "sha256-poxiGXdA2SWJQ1oFe8kh2q5T5GOytrxcAhkNv5k64Qo=";
  };

  aeronAll_1_48_4 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.4";
    hash = "sha256-6a8rgdNPkbYqo8N/7tSS4LxDF1j0s4JvDlYNSUSgrog=";
  };

  aeronSamples_1_48_4 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.4";
    artifactId = "aeron-samples";
    hash = "sha256-nB5YqF+jd2C8f++1pH36aZNtuscfP5ZMKx/6W3iiz4I=";
  };

  aeronAll_1_48_3 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.3";
    hash = "sha256-VEyowi5J7mJWQ+Xj8dO7iL2cHLkeEzcJZkk5yyuDeuU=";
  };

  aeronSamples_1_48_3 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.3";
    artifactId = "aeron-samples";
    hash = "sha256-/E7fF8Np8D3/DYHYLeRjLPkP3AQJ5kTYvZRsQmyUBzk=";
  };

  aeronAll_1_48_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.2";
    hash = "sha256-PQFlitiG43NO8zx/JfXiu7R5x/cYU/o5/x9U4/CioEw=";
  };

  aeronSamples_1_48_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.2";
    artifactId = "aeron-samples";
    hash = "sha256-nQ4kv/nQV0zkDgCL716AtRzEK/FDenHZMFNOhgVkd3s=";
  };

  aeronAll_1_48_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.1";
    hash = "sha256-ZRf4YZLxF1O6GhWpCFS/PJqIHyti3dHCXPoxuuiJEz0=";
  };

  aeronSamples_1_48_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.1";
    artifactId = "aeron-samples";
    hash = "sha256-wtCOtwtp6hQUm7SfCV5yP4bwxufs8kRgA4V9/LRoAls=";
  };

  aeronAll_1_48_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.48.0";
    hash = "sha256-eUc9tdR6iOGivovzX00VxLuHvEcXMFKxs2oJqug+ayA=";
  };

  aeronSamples_1_48_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.48.0";
    artifactId = "aeron-samples";
    hash = "sha256-31WO354XNsR2sZNPoh9kCNfSTz/ZM44IoRnmsx1iwMU=";
  };

  aeronAll_1_47_7 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.7";
    hash = "sha256-8j2nKjAjZ3tpGbCPtQ3opGL4y3vVR2kC5Wh8xQvVG8Q=";
  };

  aeronSamples_1_47_7 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.7";
    artifactId = "aeron-samples";
    hash = "sha256-zKan26LpNFOAst78qN0S9tmG59oKKowVphCYKfMu1lg=";
  };

  aeronAll_1_47_5 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.5";
    hash = "sha256-Hi7I/N+L4l05rNjfqPf4fUEFOAzt8FWx5T9UDAdVOLI=";
  };

  aeronSamples_1_47_5 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.5";
    artifactId = "aeron-samples";
    hash = "sha256-VFFfZKosTfMx1/C8qgSZNpYGP9oqN2y+rcbyTNH7vYE=";
  };

  aeronAll_1_47_4 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.4";
    hash = "sha256-PHc3vcRYI1rIJanrNyz7wCFE9znzPZMprPGO+oO8Tgc=";
  };

  aeronSamples_1_47_4 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.4";
    artifactId = "aeron-samples";
    hash = "sha256-z/FubK2sIDm8KtlaNwrO1nTlZrw+PC9tjGoiWbe7wBE=";
  };

  aeronAll_1_47_3 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.3";
    hash = "sha256-K5pVvHY0jltueoEjTv8tr9z/EtTwkhLjgE9Qw+mtN50=";
  };

  aeronSamples_1_47_3 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.3";
    artifactId = "aeron-samples";
    hash = "sha256-6HU7ykfDXlrQCdB5hYjZsQV+s0yFybXKqN8QHkEqSrw=";
  };

  aeronAll_1_47_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.2";
    hash = "sha256-qQAp3YcuIoxIJKgxoZ1ahNGRjS+b+Vr6PicN3S4xYUw=";
  };

  aeronSamples_1_47_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.2";
    artifactId = "aeron-samples";
    hash = "sha256-GVmAxQQZrfixMqylDh/TNXJk4cF0Z1Tg/iTaeohRrdw=";
  };

  aeronAll_1_47_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.1";
    hash = "sha256-QoKJxdkrZ8P7JwCFUGZ1lukG/Q4MgwksAp1R5RdVea0=";
  };

  aeronSamples_1_47_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.1";
    artifactId = "aeron-samples";
    hash = "sha256-FPkDrp0vyStm62Kf+F160KTXhNu5CdaQaB48uJkNC78=";
  };

  aeronAll_1_47_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.47.0";
    hash = "sha256-CfWsJBpk637o+CKkvpAMS+muEY/8tCh4SkEML8kYY1k=";
  };

  aeronSamples_1_47_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.47.0";
    artifactId = "aeron-samples";
    hash = "sha256-QVlBif/EmzFTB3XPLWXRdZME46Ipky+O300AH+kd9+M=";
  };

  aeronAll_1_46_9 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.9";
    hash = "sha256-HlIZfQHb3lKE773cE3bWZfAmkUkHD9qhUqHwlPLSvrw=";
  };

  aeronSamples_1_46_9 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.9";
    artifactId = "aeron-samples";
    hash = "sha256-o1PcXx8/z+rDHzTP/zSK2LjLM1TRmqSxW/KtCNBzsuc=";
  };

  aeronAll_1_46_8 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.8";
    hash = "sha256-+Y6kz+rvnzw4Q/K00Y1us3XQAkHpUSoe1nAS9yS6U4I=";
  };

  aeronSamples_1_46_8 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.8";
    artifactId = "aeron-samples";
    hash = "sha256-7kT+Ueg9RxrjKmLSfuUMpqbhUkGwGq0P3fpw2J1ruyg=";
  };

  aeronAll_1_46_7 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.7";
    hash = "sha256-3tLtPFtzmR4xxDmnViopTl1VZvlVw6noEImiimtbnVU=";
  };

  aeronSamples_1_46_7 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.7";
    artifactId = "aeron-samples";
    hash = "sha256-XaG8r2a2xXRUqdgK491KOSlptSu7dM3vzEHAh91aBqI=";
  };

  aeronAll_1_46_6 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.6";
    hash = "sha256-PMcXyzpjBkBC4qnb76D+22qPdgs7mhagZDWvGt9CXwk=";
  };

  aeronSamples_1_46_6 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.6";
    artifactId = "aeron-samples";
    hash = "sha256-JBf5531tiRY8w1lSPfic2TnepNln6CJ3PC9S56Fi68Q=";
  };

  aeronAll_1_46_5 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.5";
    hash = "sha256-ozFVbbNqqYb+giORCtTkNBcn06F0Lfu12Eyd5r/E370=";
  };

  aeronSamples_1_46_5 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.5";
    artifactId = "aeron-samples";
    hash = "sha256-0U/Ye9VcCeCtpBdBE7JUaEHe4wsE+yoa+ndLPVJiuBs=";
  };

  aeronAll_1_46_4 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.4";
    hash = "sha256-9TMGUZ9NUYMXihSFElifeqpJc0Sz7ks9NOcvjUSofaM=";
  };

  aeronSamples_1_46_4 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.4";
    artifactId = "aeron-samples";
    hash = "sha256-qo+HRhsdK/LLpAcZz4M4gxlngnokYIaJc1F/KMX8sDQ=";
  };

  aeronAll_1_46_3 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.3";
    hash = "sha256-lToJIeTM84rAA/oiNqRNdYs5Ropfuw9WJ08Nb0m87MQ=";
  };

  aeronSamples_1_46_3 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.3";
    artifactId = "aeron-samples";
    hash = "sha256-MRNGUCOW3w7gctNLsle39Zus89RBS1ukc34o4pzHOnU=";
  };

  aeronAll_1_46_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.2";
    hash = "sha256-2iwmx1X1gbjUabRyCR6Ek6iuDKhtvgEonwBdbF0h3MY=";
  };

  aeronSamples_1_46_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.2";
    artifactId = "aeron-samples";
    hash = "sha256-jv8tWpuuRnCQSlGGtd9ger562IF/5x0wSEtrlM1s1Ks=";
  };

  aeronAll_1_46_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.1";
    hash = "sha256-KH2mt64ewpdwLOM7q95l0j3ftLOCu3uICcaVUXe/vyY=";
  };

  aeronSamples_1_46_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.1";
    artifactId = "aeron-samples";
    hash = "sha256-IF9dRX/EUUF8An/baMxb9iEXq/wZlvvgdzKIk2c8+aA=";
  };

  aeronAll_1_46_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.46.0";
    hash = "sha256-ngFeYSDJxxqxawtGrALZrsjRO9WlPdnhdO9NuZKhPr8=";
  };

  aeronSamples_1_46_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.46.0";
    artifactId = "aeron-samples";
    hash = "sha256-arnWZD5znkrnn4usKG2R3gdUXljYKvoibFQ0b466iks=";
  };

  aeronAll_1_45_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.45.2";
    hash = "sha256-m1FJwC+1ZZlCPTU9KksLq7ozP3X1v7/kZaCb/vFwveQ=";
  };

  aeronSamples_1_45_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.45.2";
    artifactId = "aeron-samples";
    hash = "sha256-RB51I7WjV19pT7FCUH9FVrcbt64vjPIjMjRxgLIzEjw=";
  };

  aeronAll_1_45_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.45.1";
    hash = "sha256-cD50jk95OAcdPKJuc45t1O6WVRgM2j1gMZ5IudbL4U8=";
  };

  aeronSamples_1_45_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.45.1";
    artifactId = "aeron-samples";
    hash = "sha256-QSC5Yp35eJjUHByShdQWDP14jW1Y3pL3osLDGLsxsqg=";
  };

  aeronAll_1_45_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.45.0";
    hash = "sha256-gImfORn61k1fVyqPfr5Uk2Hu5yPfnShCXIUB3qSuFnI=";
  };

  aeronSamples_1_45_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.45.0";
    artifactId = "aeron-samples";
    hash = "sha256-7o37/YzQHTBguTlpoIXFa8JNFtyG7zKKnVdijIqAeDY=";
  };

  aeronAll_1_44_7 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.7";
    hash = "sha256-ZbM17fXbCZQWYjE1QG6MO506sMqth9ukD1an3RbxypA=";
  };

  aeronSamples_1_44_7 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.7";
    artifactId = "aeron-samples";
    hash = "sha256-vBtx5bN4JtOhvQwoHAof1Y7uLPiadQCNscw5eiaYDec=";
  };

  aeronAll_1_44_6 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.6";
    hash = "sha256-FJSPOvjXgcuqQQn8VuXz87sj4qfN7Ayt0CHg6CE2uHA=";
  };

  aeronSamples_1_44_6 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.6";
    artifactId = "aeron-samples";
    hash = "sha256-9NKudRW06/Q7xg/tDaVixBy1J0Pv3Y6FGOq0oG/IXO0=";
  };

  aeronAll_1_44_5 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.5";
    hash = "sha256-s9Jo2sU4obp6OrfLZjJvRlXYpyg3gsVnYH5xNQSjQSQ=";
  };

  aeronSamples_1_44_5 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.5";
    artifactId = "aeron-samples";
    hash = "sha256-hvRBaMoEM2KTHDXLruRnrUMi7VQH8QdDr79y1pLk/PA=";
  };

  aeronAll_1_44_4 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.4";
    hash = "sha256-CfoB7zJ4ZWZXOvy7fZoCg5zCiHI+6CTxLd7UgWslC5I=";
  };

  aeronSamples_1_44_4 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.4";
    artifactId = "aeron-samples";
    hash = "sha256-ZGkYlQCV60R1Ua3ecqBkCD3CN2r+/opx1oI1lKsqC7w=";
  };

  aeronAll_1_44_3 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.3";
    hash = "sha256-uqjLQUE6IEvGMwZqUOocL0NfK+dPIaQAJTAILIK6Kao=";
  };

  aeronSamples_1_44_3 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.3";
    artifactId = "aeron-samples";
    hash = "sha256-EfkhMx4iQIDqk3jnVf1oEvb21sN9GyLwJJjok619YW0=";
  };

  aeronAll_1_44_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.2";
    hash = "sha256-C3xr8OeVVpnmE70j+5meawWg+56/FhIBqQm9BTwbOj4=";
  };

  aeronSamples_1_44_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.2";
    artifactId = "aeron-samples";
    hash = "sha256-laY1xdgaBwwCVdAUrJtrFW2rduguRdcpTaglcWa0jB0=";
  };

  aeronAll_1_44_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.1";
    hash = "sha256-O80bWp7F6mRh3me1znzpfFfFEpvvMVjL4PrAt7+3Fq0=";
  };

  aeronSamples_1_44_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.1";
    artifactId = "aeron-samples";
    hash = "sha256-ZSuTed45BRzr4JJuGeXghUgEifv/FpnCzTNJWa+nwjo=";
  };

  aeronAll_1_44_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.0";
    hash = "sha256-j7WXJaIQZPKOTLmZg+nGxLUowYAuZYj062pmxS0ycnk=";
  };

  aeronSamples_1_44_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.0";
    artifactId = "aeron-samples";
    hash = "sha256-DXsYKnFvQT2BRGZyLXIfLBxglZMFRKBG3VDXD0UITLU=";
  };

  aeronAll_1_43_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.43.0";
    hash = "sha512-ZKjUA1Kp++RLnCNUOi2K/iGc4zIIR4pC4j8qPfO+rcgp7ghZfgsXO8sB+JD307kzeikUXnPFX7ef28DlzI8s8Q==";
  };

  aeronSamples_1_43_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.43.0";
    artifactId = "aeron-samples";
    hash = "sha512-a/ti4Kd8WwzOzDGMgdYk0pxsu8vRA4kRD9cm4D3S+r6xc/rL8ECHVoogOMDeabDd1EYSIbx/sKE01BJOW7BVsg==";
  };

  aeronAll_1_42_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.42.1";
    hash = "sha512-pjX+JopK6onDwElMIroj+ZXrKwdPj5H2uPg08XgNlrK1rAkHo9MUT8weBGbuFVFDLeqOZrHj0bt1wJ9XgYY5aA==";
  };

  aeronSamples_1_42_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.42.1";
    artifactId = "aeron-samples";
    hash = "sha512-4JnHn22vJf2lmOg6ev5PD+/YiaL3KgfuyWAK92djX3KBVXO7ERMY2kH79dveVCJG1rbekvE1j1pnjaAIxwJcqg==";
  };

  aeronAll_1_42_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.42.0";
    hash = "sha256-rcUKHUh2rsBvO8kn2x+wYFRuM9XV21hINwFG7ej6uyw=";
  };

  aeronSamples_1_42_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.42.0";
    artifactId = "aeron-samples";
    hash = "sha256-dmLEuEcgUuoEBEM0zW+c+0o6oOpIk+5FCzZgP5j1jXk=";
  };

  aeronAll_1_41_6 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.6";
    hash = "sha256-YUfQ98lGEeGjl1LB12tP9fON+KycMUJFI7ntqsYa3O8=";
  };

  aeronSamples_1_41_6 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.6";
    artifactId = "aeron-samples";
    hash = "sha256-vaO2meykLq5aK6Y0DINcVCq920Qns8GCFu18CavCvis=";
  };

  aeronAll_1_41_5 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.5";
    hash = "sha256-+yYOBwRsWgAtmDplB9dltU76wTX650KharSkMjWlG6M=";
  };

  aeronSamples_1_41_5 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.5";
    artifactId = "aeron-samples";
    hash = "sha256-1RHFDMtaAJHKNdz32Aeo6YplvoMDJerQRi10NUyp/OI=";
  };

  aeronAll_1_41_4 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.4";
    hash = "sha256-Z06nAaCO1LU6ChNm4YnipuUNgusY7iY6WhV8AeBPRoE=";
  };

  aeronSamples_1_41_4 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.4";
    artifactId = "aeron-samples";
    hash = "sha256-9gyKDu7R/Q8HtkCR5D1ohZnVa1jIOv5Z0lgOcRIumCw=";
  };

  aeronAll_1_41_3 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.3";
    hash = "sha256-aQ+oZ6oqi853fZfwRcGpgRsuEAfP7AJsu5C0pfwxlzU=";
  };

  aeronSamples_1_41_3 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.3";
    artifactId = "aeron-samples";
    hash = "sha256-FTiz5IrPoE1zWNjAym4ynjvny0p8uP7QzizK1jCJKgM=";
  };

  aeronAll_1_41_2 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.2";
    hash = "sha256-0XSoKbFnhEwOlx0+9cJj/Qf6XAUjtskun9BwIq/WxW8=";
  };

  aeronSamples_1_41_2 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.2";
    artifactId = "aeron-samples";
    hash = "sha256-7ht2Jklvx3cfk2PopRjUVDQ0Uo+5M5262SI91ItS9Ow=";
  };

  aeronAll_1_41_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.1";
    hash = "sha256-/JufYICrSefm9nGlVcfQHcUkYMnzrZcNDjB8fAfSKGE=";
  };

  aeronSamples_1_41_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.1";
    artifactId = "aeron-samples";
    hash = "sha256-6/o1t6/ehYYhMqU6pYQ0uScZhsZTuowr0uwJ3TbmtHk=";
  };

  aeronAll_1_41_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.41.0";
    hash = "sha256-g2dFf+htF72ByJCcjKuHtLuehLtjjjpqjvWq1rTkmYg=";
  };

  aeronSamples_1_41_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.41.0";
    artifactId = "aeron-samples";
    hash = "sha256-nUX9JM0p06m0XyH4ugPXQ0+Fc9ydmhJlaND+VUCZ788=";
  };

  aeronAll_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-all";
    hash = "sha512-NyhYaQqOWcSBwzwpje6DMAp36CEgGSNXBSdaRrDyP+Fn2Z0nvh5o2czog6GKKtbjH9inYfyyF/21gehfgLF6qA==";
  };

  aeronSamples_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-samples";
    hash = "sha512-vyAq4mfLDDyaVk7wcIpPvPcxSt92Ek8mxfuuZwaX+0Wu9oJCpwbnjvS9+bvzcE4qSGxzY6eJIIX6nMdw0LkACg==";
  };

  aeronAll = aeronAll_1_49_0;
  aeronSamples = aeronSamples_1_49_0;

in
stdenv.mkDerivation {

  inherit pname version;

  buildInputs = [
    aeronAll
    aeronSamples
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/share/java"
    ln --symbolic "${aeronAll.jar}" "$out/share/java/${pname}-all.jar"
    ln --symbolic "${aeronSamples.jar}" "$out/share/java/${pname}-samples.jar"

    runHook postInstall
  '';

  postFixup = ''
    function wrap {
      makeWrapper "${jdk11}/bin/java" "$out/bin/$1" \
        --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
        --add-flags "--class-path ${aeronAll.jar}" \
        --add-flags "$2"
    }

    wrap "${pname}-media-driver" io.aeron.driver.MediaDriver
    wrap "${pname}-stat" io.aeron.samples.AeronStat
    wrap "${pname}-archiving-media-driver" io.aeron.archive.ArchivingMediaDriver
    wrap "${pname}-archive-tool" io.aeron.archive.ArchiveTool
    wrap "${pname}-logging-agent" io.aeron.agent.DynamicLoggingAgent
    wrap "${pname}-clustered-media-driver" io.aeron.cluster.ClusteredMediaDriver
    wrap "${pname}-cluster-tool" io.aeron.cluster.ClusterTool
  '';

  passthru = {
    jar = aeronAll.jar;
  };

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    mainProgram = "${pname}-media-driver";
    maintainers = [ maintainers.vaci ];
    sourceProvenance = [
      sourceTypes.binaryBytecode
    ];
  };
}
