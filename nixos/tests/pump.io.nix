# This test runs pump.io with mongodb, listing on port 443.

import ./make-test.nix ({ pkgs, ...} : let
  snakeOilKey = ''
    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqVemio78R41Tz
    MnR2zFD/wFT0iScOpFkuytNmuPf28FLaa9wSBWmuAGbEi7wBIfw8/bUqFBTQp2G1
    m1cmcCKxhmvvOkGs89eM131s1lW/bXU3zYso4e7724kHwU65jRlQs6cFWIlmW7V5
    3HQobP05dy+zPpujPPSlOQ0qYViR1s+RgZI8r0wS2ZDsliNtQwBLJSIvX6XVnXLo
    F/HmF4/ySJ9pL2AxQXCwZE8SfCzHpArs9COIqTaAuwB79kxWSFQJewmab74BXiM6
    9FMCtHON24Pl7OR9sRJHH8rMEzUumppmUeCNEzABjzQQ7svR18cmbzRWetp0tT9Y
    7rj6URHHAgMBAAECggEAGmbCldDnlrAzxJY3cwpsK5f2EwkHIr/aiuQpLCzTUlUh
    onVBYRGxtaSeSSyXcV2BKTrxz5nZOBYZkPqI4Y5T8kwxgpz2/QW2jUABUtNN6yPe
    HU4gma+bSTJX5PnTZ/M0z0tpQezdLx5b3I2M+48ZGMUegZvcp8qU6N8U6VK5VbFD
    DMTGL4b+Kc9HScRkCJjU3FfQcqf9Ml5w9jzHSeHImYEDrG0nX8N8EImRCBXbgxCl
    5XT1h6LFUGdr+N6n2w56+6l8OZZVmwj1NdF6NJybUQl4Y7b0niA+5czzjRt/YUjZ
    HW0fXmx3XlbYGWYdMdS+VaIW6pkUpm8kZkqjngqLwQKBgQDfhbFQmg9lsJQ8/dQZ
    WzRNsozHKWkQiZbW5sXBWygJbAB3Hc8gvQkuZe9TVyF99cznRj6ro6pGZjP0rTdY
    3ACTL+ygRArcIR6VsJCIr6nPvBLpOoNb8TQeKPmHC2gnSP9zaT/K2lldYISKNaYQ
    0seB2gvZhIgMgWtZtmb3jdgl9wKBgQDDFdknXgvFgB+y96//9wTu2WWuE5yQ5yB7
    utAcHNO9rx5X1tJqxymYh+iE8HUN25By+96SpNMQFI+0wNGVB00YWNBKtyepimWN
    EUCojTy+MIXIjrLcvviEePsI4TPWYf8XtZeiYtcczYrt/wPQUYaDb8LBRfpIfmhr
    rCGW93s+sQKBgEDOKTeeQyKPjJsWWL01RTfVsZ04s155FcOeyu0heb0plAT1Ho12
    YUgTg8zc8Tfs4QiYxCjNXdvlW+Dvq6FWv8/s0CUzNRbXf1+U/oKys4AoHi+CqH0q
    tJqd9KKjuwHQ10dl13n/znMVPbg4j7pG8lMCnfblxvAhQbeT+8yAUo/HAoGBAL3t
    /n4KXNGK3NHDvXEp0H6t3wWsiEi3DPQJO+Wy1x8caCFCv5c/kaqz3tfWt0+njSm1
    N8tzdx13tzVWaHV8Jz3l8dxcFtxEJnxB6L5wy0urOAS7kT3DG3b1xgmuH2a//7fY
    jumE60NahcER/2eIh7pdS7IZbAO6NfVmH0m4Zh/xAoGAbquh60sAfLC/1O2/4Xom
    PHS7z2+TNpwu4ou3nspxfigNQcTWzzzTVFLnaTPg+HKbLRXSWysjssmmj5u3lCyc
    S2M9xuhApa9CrN/udz4gEojRVsTla/gyLifIZ3CtTn2QEQiIJEMxM+59KAlkgUBo
    9BeZ03xTaEZfhVZ9bEN30Ak=
    -----END PRIVATE KEY-----
  '';

  snakeOilCert = ''
    -----BEGIN CERTIFICATE-----
    MIICvjCCAaagAwIBAgIJANhA6+PPhomZMA0GCSqGSIb3DQEBCwUAMBcxFTATBgNV
    BAMMDGIwOTM0YWMwYWZkNTAeFw0xNTExMzAxNzQ3MzVaFw0yNTExMjcxNzQ3MzVa
    MBcxFTATBgNVBAMMDGIwOTM0YWMwYWZkNTCCASIwDQYJKoZIhvcNAQEBBQADggEP
    ADCCAQoCggEBAKpV6aKjvxHjVPMydHbMUP/AVPSJJw6kWS7K02a49/bwUtpr3BIF
    aa4AZsSLvAEh/Dz9tSoUFNCnYbWbVyZwIrGGa+86Qazz14zXfWzWVb9tdTfNiyjh
    7vvbiQfBTrmNGVCzpwVYiWZbtXncdChs/Tl3L7M+m6M89KU5DSphWJHWz5GBkjyv
    TBLZkOyWI21DAEslIi9fpdWdcugX8eYXj/JIn2kvYDFBcLBkTxJ8LMekCuz0I4ip
    NoC7AHv2TFZIVAl7CZpvvgFeIzr0UwK0c43bg+Xs5H2xEkcfyswTNS6ammZR4I0T
    MAGPNBDuy9HXxyZvNFZ62nS1P1juuPpREccCAwEAAaMNMAswCQYDVR0TBAIwADAN
    BgkqhkiG9w0BAQsFAAOCAQEAd2w9rxi6qF9WV8L3rHnTE7uu0ldtdgJlCASx6ouj
    TleOnjfEg+kH8r8UbmRV5vsTDn1Qp5JGDYxfytRUQwLb1zTLde0xotx37E3LY8Wr
    sD6Al4t8sHywB/hc5dy29TgG0iyG8LKZrkwytLvDZ814W3OwpN2rpEz6pdizdHNn
    jsoDEngZiDHvLjIyE0cDkFXkeYMGXOnBUeOcu4nfu4C5eKs3nXGGAcNDbDRIuLoE
    BZExUBY+YSs6JBvh5tvRqLVW0Dz0akEcjb/jhwS2LmDip8Pdoxx4Q1jPKEu38zrr
    Vd5WD2HJhLb9u0UxVp9vfWIUDgydopV5ZmWCQ5YvNepb1w==
    -----END CERTIFICATE-----
  '';

  makePump = { opts ? { } }:
    {
      enable = true;
      sslCert = pkgs.writeText "snakeoil.cert" snakeOilCert;
      sslKey = pkgs.writeText "snakeoil.pem" snakeOilKey;
      secret = "test";
      site = "test";
    } // opts;

in {
  name = "pumpio";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rvl ];
  };

  nodes = {
    one =
      { config, pkgs, ... }:
        {
          services = {
           pumpio = makePump { opts = {
             port = 443;
           }; };
           mongodb.enable = true;
           mongodb.extraConfig = ''
             nojournal = true
           '';
          };
          systemd.services.mongodb.unitConfig.Before = "pump.io.service";
          systemd.services."pump.io".unitConfig.Requires = "mongodb.service";
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("pump.io.service");
    $one->waitUntilSucceeds("curl -k https://localhost");
  '';
})
