{ stdenv, lib, fetchurl, fetchFromGitHub }:

rec {
  makeLanguages = { tessdataRev, tessdata ? null, all ? null, languages ? {} }:
    let
      tessdataSrc = fetchFromGitHub {
        owner = "tesseract-ocr";
        repo = "tessdata";
        rev = tessdataRev;
        hash = tessdata;
      };

      languageFile = lang: hash: fetchurl {
        url = "https://github.com/tesseract-ocr/tessdata/raw/${tessdataRev}/${lang}.traineddata";
        inherit hash;
      };
    in
      {
        # Use a simple fixed-output derivation for all languages to increase nix eval performance
        all = stdenv.mkDerivation {
          name = "all";
          buildCommand = ''
            mkdir $out
            cd ${tessdataSrc}
            cp *.traineddata $out
          '';
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = all;
        };
      } // (lib.mapAttrs languageFile languages);

  v3 = makeLanguages {
    tessdataRev = "3cf1e2df1fe1d1da29295c9ef0983796c7958b7d";
    tessdata = "sha256-591NFrPdZ9orB9PtxKqsukh6aAq5DDO8yJ19W/Ywi+w=";
    all = "sha256-FuIGfE0bNPvB8ip6cL8GRl0U9T7oD6sx+38CaGyCRno=";

    # Run `./fetch-language-hashes <tessdataRev>` to generate these hashes
    languages = {
      afr = "sha256-birhlXVhETYI4SYipFROA0xGpJtvnEqjEVGlSPy3upU=";
      amh = "sha256-BJ73M3RYuc7ZuLBLr52GLilxdA9mUhXkUK9vPXDTbPE=";
      ara = "sha256-IcmKr3rroicawMxKNj02TYBmSdfLC8q4XUuaOF9JZFo=";
      asm = "sha256-0LW2Utq5Resb+MKweGRxLHwzQXLDaqHJ6QfD60vAfDA=";
      aze = "sha256-vCtISRgsNyDAmEf1pkXR40gawizvUahZUKFP3OE44F8=";
      aze_cyrl = "sha256-uFMD0kJq6x0Ho2ofBvd5pghZMzbmgCuslmx6JPpzSzY=";
      bel = "sha256-QvPRVfIO6TNpeKrOZD14FM4JJUfXXWXwVMyBGTfy+BM=";
      ben = "sha256-FXgmuvSAY1R7d5PhveDJ+C1IQ0iPtcfgIVX2YqcI6GA=";
      bod = "sha256-Vql4san2bCVfcUVEG6YHdXIWfhkluAV0R9r9n0Y5mGc=";
      bos = "sha256-5J2i7uhl7cHYHW6izqvAvb638nW22Hj7O2R0emQjIOM=";
      bul = "sha256-ygvSU7SrYgLbXoss7LxCGbT3JeUUaMq/W8mTOOLD3jM=";
      cat = "sha256-Ka9nRn7Bsf/U0tl0jwIZ8iIJdLDlOmbscjTxdotD/E0=";
      ceb = "sha256-wSEDsspJiHLcctcemjMAZjU6zSx1is4dP1nBTa4lNrw=";
      ces = "sha256-YMWOzZeHWkHsyuSEai5L90yw5LwGbRvEMJGcdqGfs38=";
      chi_sim = "sha256-MjrnTUov9J6TLbtNYoL+Dmfd+v2gdeyFgD7NB3IHRUw=";
      chi_tra = "sha256-d01Wa9CzbktsB0Fd+ltrV/6yV1sfXyMdf+AaUtrF3Q4=";
      chr = "sha256-i7IPinjjGkgC+p8eB1y33o18LqxbezOUKm2Cq+B4Osw=";
      cym = "sha256-B8jj1qE5cR3NtMkvkNGIAvbhXeOTMViNcT/nypJb3DQ=";
      dan = "sha256-+VIag4GrGCO+CAj5M6m7jxFylopE45HjcLH+m02RPug=";
      dan_frak = "sha256-cYNhenunY/WcHth+vItIhdoDqbuiuZ1GAK+sWP0osa8=";
      deu = "sha256-y360Kn6XLOx++QT+gYJde1R8Rt9oTIFP2xGpMLE7yjo=";
      deu_frak = "sha256-y7IA45RIXFtRXeIDljwqdsFL3vLPJYIZ7PK8rPbMk/g=";
      dzo = "sha256-tR/wbc8wEjWfqoIcPSReTIofS2WuX2FOSrH/E2sEn7k=";
      ell = "sha256-u+DtB1jGkEMRSxP8jwCkI0LGR/J741LAW0l44mU4DmQ=";
      eng = "sha256-wFFcnx4MeeEGn8wFwrL2poQfteEILWldsWAzPBFU8G0=";
      enm = "sha256-hliaWydvYxeD4DhyNkD/JAYIixdivVw+ftcHPnYPxoM=";
      epo = "sha256-xCTSmiNBRpNT//JfRmtn3jkEFWvBUXwqG6OzVUuBtPg=";
      equ = "sha256-OvQ6JCDOkn285oR01kRiWUcYmoLOauT9MhBjmRRoGds=";
      est = "sha256-j6jyZJrjFok4lnlTzjrLwZ2MDgcCjARhwppJGDBFlIo=";
      eus = "sha256-3Jo0mQQMYA6sBwNiabvBauHlhFyrMuG2Jypwem5Nmgw=";
      fas = "sha256-XUZC4yxm6UULypwM7SLK6TGINArP2MbKcX8C5he5wVQ=";
      fin = "sha256-+DDGJfY1pjfLEaalZRJrGuEFwkrp/Xy5LI1RMMcYTPE=";
      fra = "sha256-hq+yOtFGRn8mPoreVv05UbHMKPjE7rw0+ZPTwC2Ip6s=";
      frk = "sha256-t0UWINMKPabRxryZiwiplt++USa4lh7mJuKMdMPJ1Zo=";
      frm = "sha256-trW44scT9PZqr2+Vb7dh6oxlGLkq9MURpiozfj4c3wM=";
      gle = "sha256-6n4lfOjP5yJ5UFoVTB1VyhBoeAS7/PdpRsLUYutEH9k=";
      glg = "sha256-X5AhWWqOUwYWWhNCnNFtJ9UXYFZ0wV1p5XEwer2Ktjk=";
      grc = "sha256-q9sWDD0MNCTjVPFUWRmL/KRw3EK2o5TKUh53hkcKIhM=";
      guj = "sha256-VAUO0X64PQ4lihJ9kjCLA3zeNAKFgdfQ4qkDVzut6DY=";
      hat = "sha256-aIsDZWV2q8ffaG9OT6y3h5j/Gd0NygECYgms1WmtIx0=";
      heb = "sha256-T3koiv3pFi7ieEHw3pmeaQAizx470XI+NMqPGJxL6ps=";
      hin = "sha256-bplFnb3MQL/sEydHvCMwVJFr7Z2gL4lWfJOIwy4v1u4=";
      hrv = "sha256-w3oh7zZ4gBP3GpG6ZJ9K3EwP+O7Z6LKoqm2JHbtpOJc=";
      hun = "sha256-pnBNLo2uYiQFlzQsM3Ns172DaojhiPx02wOOyHvj/6c=";
      iku = "sha256-q4GeYBOPhDJQiLEZcxe14hAjLywQRrKeZB6TFALbPuw=";
      ind = "sha256-NzjesAe6+fAbOmAYNQA/ccMU0blV+KdDY09vHsgiDYg=";
      isl = "sha256-v2tsHHb4vLn3gNwXLYth02X6tDSxXoQnfc1s19B8dgA=";
      ita = "sha256-Wk5ugm4CHQTzSUwr107Rr1l3tn/e3Os8mqMP9seks9M=";
      ita_old = "sha256-P9C5+JRtoRTt7weyQv0RvGhoQjvBI+aZD+qG4oNfD6E=";
      jav = "sha256-d/G12l/6oJZyTsNpmuTb/en4VE9LdLtcLJpCJu2XXro=";
      jpn = "sha256-PDyVfLv7b+ZrOLRrwX+GFY39sWiKKijt5+4OyJH0qvI=";
      kan = "sha256-bxsg1jOTODXA7K7OQuZMYf1pDsAQ0N9S24lDPkoiU0E=";
      kat = "sha256-I9aIBop6SWlLEMh7cl44nJ3Mxm5w61KtNqztzU4BYJo=";
      kat_old = "sha256-0GWX+Xp1f1Ghw2P0v3PSck3sntwdS8f/9vSi0Uo59Ak=";
      kaz = "sha256-9WmAKI6bkL/rGSkXV9oLKT09UAYbCDE184qX/w83g0E=";
      khm = "sha256-WoT8I+5T24WLygalGpoWZhlykZGO4J54+q7ghsu2Yr0=";
      kir = "sha256-A0J7mgB7dK/OObXQJhtP5vZHbjZn3k6gwxhFjM2zMaw=";
      kor = "sha256-+zEuvhGadnPKaMCp97nd0TpwT2RgndIvL9YGiJyRjeY=";
      kur = "sha256-LIZeBRn+W4/eC24hhHRcnAbsluuT+xP7fsKYZ5q74rI=";
      lao = "sha256-rr8gJe4exxsO5TKCWCjQ0tStp/t/Wb1TXuv2OlVXbQ0=";
      lat = "sha256-Up/0i6rZ0QERaYnJj/MJRoYdO21LpkPFTMpebnM7++A=";
      lav = "sha256-Tx8GN29JjQ2uEfsDIA7hJMYV3ISP7hwFr/kYe/j2vzs=";
      lit = "sha256-FYpSd1cvBLufsHCjvACtOl/npeJYVsn5JIlmLOV7ADg=";
      mal = "sha256-CnWrck61tl1tPtBfj/d+qfzyrKd/i3QR1qYOGyG9A8U=";
      mar = "sha256-Mzbn1UBQf7btrpmJPlqphsPTZWKJFrszS+AM6kfBxys=";
      mkd = "sha256-4/QQaE6Q3HNF7CbvuCZ227AfKx7kY++1/i1IkllTPOA=";
      mlt = "sha256-EGgCdZh/8WtJQ3IdSa7LzUq56eNCDJ77oWGqpaDZ5OI=";
      msa = "sha256-0vfS1XrxrIZocDBE9IDleMMf7QNx7aKTBiT/1Gc1FxE=";
      mya = "sha256-VKDRg9eramczalBJKPPfibTJeB02CDJa3H8K0lbJ3p4=";
      nep = "sha256-DMvPyc9L5a1XX2hdH2MXa3c+7np7snAt27VpMXI5g5Q=";
      nld = "sha256-vYSTRehHb0e0DBcgT+9c9kKHJEwZudF+KX/+cPxcnLI=";
      nor = "sha256-qZAmnz2BWtIG6g8nsU0H56C+DBcTNTl7wLRuoM3P2/o=";
      ori = "sha256-TCliwoXMw8c14DHvMnGc84Vh12xcsD7LNxpy+xCbSjc=";
      osd = "sha256-nPXVdvzEdWTxEmWEHlyoOQAefm84/396rPRtFalrAP8=";
      pan = "sha256-e1UefVLiddjb3uUoAWrLIovwE7Ifz8dzM7m65ie/jbs=";
      pol = "sha256-HSKSMZ0uPGXhXxn1W5Ycm0kmUfwXnzvNIZr/58FBv5Q=";
      por = "sha256-CJ+0Gc170TUjYkTdmkuKQt/i7pfZe0ge/de5LJxjJKA=";
      pus = "sha256-q4hOL9P/cir/tmGSfhjnULSQUucxy7BeosFu94O15cc=";
      ron = "sha256-9PNhTUsAnusKtYFevvCA67p8Rws/gMn5ftbaDT9AmYY=";
      rus = "sha256-GADcrwQ+lQByafBxaKEiWM2Lh79BN2nCtaPVRR5FyrQ=";
      san = "sha256-b0ylBT8U4W2nDuO26w5VS4W9X9uO0+ya8ylZ/qQiLpk=";
      sin = "sha256-9YU8Nu/e2xQhmMpokdCidz6in1THamCJM9I4k1F4IZA=";
      slk = "sha256-ul0qugn1nhlSWDgl3XsOubpwYoPRwPk76Nc4G15eri8=";
      slk_frak = "sha256-Hn8eWerSShNtwGJumAGVlKBC5iCHv8+PD92z4oO12H8=";
      slv = "sha256-MFiE4VGgFCHoR6SjDwXpyJn879SDoS0uqODyBVNNVs4=";
      spa = "sha256-8jmFmWu8/itXhkzLCCeDwcdMh0KfBEEaBKa6TT2i79o=";
      spa_old = "sha256-XaOG/YRQhpbjrmPQo13Oe1JtW2aZSU/lOtZTh/bckXA=";
      sqi = "sha256-rs21rvcLz/o6UAZ2kQ/eHStdY3hHlgmcP92Pig3cn5c=";
      srp = "sha256-Nb/rPOFPWv64LJviSQ2zQXjA4T996AYQE6CDsWPGdBU=";
      srp_latn = "sha256-mVvApX5lqdQgkhESLm3PCuMR7v526aFE0wgrYPDQSGs=";
      swa = "sha256-jhCnJU532THt+MkzqYvls2q+H9IcMmbAZkHgRk+HnN8=";
      swe = "sha256-KmQHu/GH6x/P0WM/rpq//NYiDnq3TgXmW/FkJqyPIFA=";
      syr = "sha256-YD3JPEm4bP9OHcXcnA15D7/rj/ZM9rUhgeV6PgKNfSE=";
      tam = "sha256-f7c0foBtVA74PrnEJt3iNmommjcPEf/+c5ILtfwsJbw=";
      tel = "sha256-+0btVJoVYzve8ad2sjQxSkQzNOlnjPUVrtUsUhbLzTs=";
      tgk = "sha256-QPOySbwYy3WHvDqvs4BDXROpTJVgOzGCP5L7mN0Z0jg=";
      tgl = "sha256-55SvYHQmJpuzLu2y8gcG4nj7sA5KdcQ9xKe4yOIDOTg=";
      tha = "sha256-ykpC1Egb0Dd80CcxtRScIov3Pot6YeRLmi1eJ0vhUPg=";
      tir = "sha256-EKWKtn1ibgk5KOYCBW5ek/RsKT5fygI9UWygLKHP8fg=";
      tur = "sha256-XLzOXvtms9oQoUOX+8OojYRXufG3JLnI2WRJsVLCFnc=";
      uig = "sha256-uy+C97n4OqtNP62AYDF0q4TmaIkfnhbaHGPRX0Jurek=";
      ukr = "sha256-L4ss0PC1uGEqS4CrzrqjrEb18DaJJmKbPP9Xa52VvDE=";
      urd = "sha256-KDB7+JK4jDhWxMexkiE+qGh5np8MROXL5dpRoX+wrIM=";
      uzb = "sha256-NJE0a17k3P25IUSimi8JB/IdHncrX/7KlqXrbWRpc8o=";
      uzb_cyrl = "sha256-pSBiXV3h8Aia+DbABLLPvT/lpQhEAeTpaFjUl9FQsc0=";
      vie = "sha256-zvXmN0fIbiG8u9MLtoOhsQT5gpO3SyqJF0hw1btEQck=";
      yid = "sha256-zZm4mvPApL0hpD3UPxN+/96j3V0ZrVk+ALvUih5orck=";

    };
  };

  v4 = makeLanguages {
    tessdataRev = "4.1.0";
    tessdata = "sha256-70bp4prs1zUbSzQmcqd7v736cyYWv8oNNbmZXypik5I=";
    all = "sha256-hk+DjoVWf7RW9S+Gu9XUX8aWYYsL5dU5c6jLSKJp+MY=";

    # Run `./fetch-language-hashes <tessdataRev>` to generate these hashes
    languages = {
      afr = "sha256-XsQc6+0/SheO6dcuERKsmko4p7DdyvsSZtVdne1FLqk=";
      amh = "sha256-QIoWQufDlggA/5P5SyxmwSdQZhgXqIyFq/OULrtvO1Q=";
      ara = "sha256-IAWXZ3i7wU/Fak6o1DxggIR67ucvzCIBSI8kDayhXFs=";
      asm = "sha256-juqmGgEUh8NphXBfnlZ+LELcUQ88Q8OYaZ5nJvNOrQg=";
      aze = "sha256-7mkrPPlvOXe5FVbwgaz7sLjEQhfEj4t8HbYbhY5mUAc=";
      aze_cyrl = "sha256-bwdsYITvHB6RyRdRmSiN0dme6QUS2SignDafXGJCbek=";
      bel = "sha256-DFkWfO4s/KJmPr9NKNICeypRx1MHk0MQVfx71nX1HjY=";
      ben = "sha256-YCO2Ign/zAiUUngauWMUT3shzqePYdHPsNmNSQJJ+Cg=";
      bod = "sha256-Wc3pXuVwN/sQl3S6kUe4lEP0ToRIMtaoydFAaknpB2Y=";
      bos = "sha256-zY74ANUNk704ni8LAaViWpqjpST/7qRE6BQWYCyp/us=";
      bre = "sha256-M2cbvdi0oVzq18AEdMxyFmndEvyXT0m4psv+SBAjDhw=";
      bul = "sha256-kvd9UV+2rkcrI5rQnQwE0GU5wkBIJD8IzejRdLgXbw0=";
      cat = "sha256-Gx/vnnDYzpug7JLVBxQsjcV/QP1vsAOcE94jqUIyuqc=";
      ceb = "sha256-OR2KxjF5M8HTzuVqDutFF0QhgLV5S2iqVYRhGIjdJqE=";
      ces = "sha256-zoYe0dwg5020ScRjbUSoMELNKuuM2VyQCCk7XQ95Ajo=";
      chi_sim = "sha256-/AXYmrMdi04iaRDxaovL945DuuPiWAu1/u/QUu/as2M=";
      chi_sim_vert = "sha256-hyNJp2YWhVDeLoSrPwOCegSXVvphfaH6Fki11fe/5bg=";
      chi_tra = "sha256-VZBn3A98lHiIhHQhKdZqARfd5/T/ErJj2SFHFzSX2xQ=";
      chi_tra_vert = "sha256-hGJKlSn650+h69dGyAl1gh9wPYIamPcon0WFx3xjiYE=";
      chr = "sha256-1BAbYlHTt6/Kr+S5IDoqWSQd6WS3E6ZlGycdwYxCGKc=";
      cos = "sha256-3dPsVxypXXNMP5+hOTMHRXmOAFK0Q8UuALZAxGHoM30=";
      cym = "sha256-TUCW6JEQWoU4jm1Jo5tRNTQvthLf0TX+wr0P4i5L844=";
      dan = "sha256-Ii+1rRqxMffokBlD1uOo5zOvMNs2wu8h5Nr73aGqOco=";
      dan_frak = "sha256-AFbqCzSZD7rGCXyQyResnEhVgNKvdAsZPvav2nF7jJ8=";
      deu = "sha256-iWs7SVZQOrnaoQKF2zMIgbLXS3DYibeSYsxTS57GmaQ=";
      deu_frak = "sha256-p649BhD51E1V3QbCquokQd9UI68FXCm4O6wEJ8aFEIo=";
      div = "sha256-gXx/fy6jvdvDjgrMjzpXt03BaqoehOcvJkzDDktOtSY=";
      dzo = "sha256-K/AnF2DDwn8z6L3hMJS0B2guCY/mUl1/8fh9xV5mZ/4=";
      ell = "sha256-D2uLRAmE/pFYAZ1yLGJPMqYuD5myHyJHSSGQpFCoHsI=";
      eng = "sha256-2qDJfWUcGfujsl6BMXzWl+mQjIIICQyUw5BTgcI/wEc=";
      enm = "sha256-dXtF3SVXfG4Xo/j45IWvoy5diImsTD4IjQsNGjcOGbY=";
      epo = "sha256-yRIyCVJRzisB16vfmP7bYAU5XvRY9y0G5xsUcFYjL8o=";
      equ = "sha256-j2YDI9int6Do0vrho0OebkcCIr+7mQsqt/6eH7R5HAs=";
      est = "sha256-9KGCAXcFltDbv7sWOFTAwBQzkWlV1pXjcscv46F6vss=";
      eus = "sha256-tyZYz8/JGp+gA6ZIvTNAKU6d3EKa5rwVQAZFfao9UTE=";
      fao = "sha256-CnHutxfwLTEo1s2UZ86ApCnBlRzPf+rXVH+h4CQZZNg=";
      fas = "sha256-CzsV6cy+Q1glGH+norsif1Vd03z4USbGz0WcpKabkp8=";
      fil = "sha256-H65YA5/Mj1Y1dXmhCgSeJcaOewhBW4LGT64d8dAc4Vw=";
      fin = "sha256-T6zqajTwlK8megAusSaVRyx5NjtyusIEEyufam3yg/E=";
      fra = "sha256-6sAcHXJUDWCQ+st7L0LdCi7o/FfFvhsgVIrmaOJ2GRM=";
      frk = "sha256-18fZ/9zd1naVD+SYLIcz7UrbY73NxO8lLLRh2XuvmBU=";
      frm = "sha256-wm9GwlmBr2Ia87ipNm09NgP2r/JVfrv/opuCBo33Bik=";
      fry = "sha256-8BRoZ3OCITSfjKxNPPVlC2ZmDaaEXg+pTXlSmB7KBEU=";
      gla = "sha256-WU0FUhx4ajDD4V6EtXcH/nDlSJm6oWVb+ooXUBb0LZ4=";
      gle = "sha256-s3ZdQ5gYnlkswhUH6WnztMGEDYWjETPeJUVt9n+BB+E=";
      glg = "sha256-5AENqozozcDbPmJsbn7WgvFg1LKDRFI1UMNfmMPXugc=";
      grc = "sha256-1L/cwkD6HoeFM114D9zwYUohAVVpCS8CLI+TXvXQoAM=";
      guj = "sha256-pIT0pwAv9Ooi3KJoIeQEMTE6Mc1CmrkJASJ+YJ8jGwk=";
      hat = "sha256-WkPgMxD5cpv4NeDCYgpaslX3TL6HMc+p9JaJfE0oiq0=";
      heb = "sha256-fabqa3omIOyOi0HeKWehPUKWNaVmV6CzC2IlAaVz0+E=";
      hin = "sha256-zHbQn6T+0cekZ0BG4l5jdg0Mm/3OOQpSETRiw0pVbuY=";
      hrv = "sha256-91VXBv5BFRUBiIMYeoC/eNzWruTMT7zoT4xnMKtZRzU=";
      hun = "sha256-sSf5igeLuCT2JS1SMgfZBer3TwACwnTrx5+cm2wlWnA=";
      hye = "sha256-Lvd3XbnEExINu4aOQMgJEVUSnLFB1js3gXJRXg6q30U=";
      iku = "sha256-trY4sUGfNkP4gZaMWQ84hf1CddguuYs8W7CvLtC2WaU=";
      ind = "sha256-Ra2q3ocV9VPBCDNPYD8k5LyQL8Z2OJK1qSRa/iMMgrQ=";
      isl = "sha256-+CIAk5r5SrZ2wdXhXG01wflpRu684PhBSgqnLCbiUsI=";
      ita = "sha256-T3R2xhExK+uPjhgoiNoI6mQtmCSuRALMYjX2GrFAZAY=";
      ita_old = "sha256-Rqe6BVbAbZmArLvTSWBNcwk3a2akLOCzvxvIJYMhyN0=";
      jav = "sha256-FdR83e0UDnMdHBzsJIUIFNkEjcKbV1mVMMQDWaNfe6M=";
      jpn = "sha256-b0FrkC0SnYzCjpnDMkQDSxz1JUnoVg9jILBtMXhSFZo=";
      jpn_vert = "sha256-NoecGqB2NDAsncssHtT4+zR8cFrXUi3Wk+4unWgCink=";
      kan = "sha256-TRLkRNe4lc2AVrD/O1biqU4+a7Oh0bwgXLM7mc/olVE=";
      kat = "sha256-Kl4c1ZW3ERSUmjdRx/wicDkAXXcInhMI32sdxd8iJqw=";
      kat_old = "sha256-UQXCYrpz3cniTUOXc70G7rX8XptxMgD5uA2OBPVx7tU=";
      kaz = "sha256-cYeSnrIP+8cjbVlZ12GhjWKfx+t7HXp/uZrTsibwZ0A=";
      khm = "sha256-yzU4Ejok/gjjYRsaZZgDCqgZk+qISzlFixqFbL0L/VQ=";
      kir = "sha256-Q6MzrZYZXfm/7Qjdr7MI8w8UY9SY4gNilH0ahy/mfSY=";
      kmr = "sha256-5llHfGE87Pk14mkvc+a4cqb8TQXx/uVSCDhF+BkDcuk=";
      kor = "sha256-lSC/6ePPw41KgI4DawKHyIodN/uAuaCiOSjdzN0gWVs=";
      kor_vert = "sha256-CC7y5mG3c8wilEZAuY2grHamhbDbucYPdmnOWO1vu/I=";
      lao = "sha256-ha5mxb8EqMRbV8T49I/X2eBDvVCCjfdjYkQNvtCjfb8=";
      lat = "sha256-eQ/IVLwoZVqnCnduPgFFSL1C6IEYR7hKYcnlPvCw6iw=";
      lav = "sha256-goEdo/Hf7TbtvVsz4naueyXl5mvZSd9bq+p5doivGjs=";
      lit = "sha256-e5q1JBf7CJ286H/UFPrdnWgILfUnUoUbnMWtwfhcT3I=";
      ltz = "sha256-zEF9dLOAXmw77EFJWH4JWzvc6MNKRf3dQdThGO3q7Qs=";
      mal = "sha256-LbtjlyAwyMZVXleRLZn4E6r+e/WbT9m5F5KaiL6LgSg=";
      mar = "sha256-hFDLsZaxriMQwHoRRN+DGCdLZOG0Oqs6rXuylSCFXAM=";
      mkd = "sha256-T6rQudft4N7GrDaG6RXLEAewFxeRlU+0I/+6TzuPDq8=";
      mlt = "sha256-339C19/kfmP+maUlA2INzj5t4WYlO3bwyRAhroR6teY=";
      mon = "sha256-kFqPMTZu/vNkg2+/tELLm+aCeQXkwdpk1fQmuxXbeso=";
      mri = "sha256-sUAeaw9iNhstgpkpAh0jsMUv9vDNCjStpqxoIDpXjko=";
      msa = "sha256-VhF0PATZ0xvidV5QqshtgVyviYZr9+HKJ3QoZRXS/1Q=";
      mya = "sha256-YVUU69R2bHV+VYfunMDJ2bLnJ9yVcJjLJJk2pWCpkkI=";
      nep = "sha256-wxRu8CWZYdWmUzm9uR3MtRmRrO48iuRW5M91A0UFHrY=";
      nld = "sha256-sfZ2f1Da9ZA4AvuXDnufZO4fEr4LKzJN/fjosFdxVy8=";
      nor = "sha256-uFnk3iTS0jkA2ZPXSBnTMzklVBQFe1CY2tKBmhiUqiI=";
      oci = "sha256-u/UgOdCUpgbEn44h15/PsmD5/iv07D9kDy3Lpl/i+dc=";
      ori = "sha256-6GhQO+YzSoyqCS45FNDO/PwqXeTjSkoNNRuG9WUVBOo=";
      osd = "sha256-4Z8q6GB5L983LPSNjOcK5do8QFKWL+IuneH2gMN0uw4=";
      pan = "sha256-UIwPtYrp41yqVx3oW8zlnqW373UaXaJ/96WbS1KexQQ=";
      pol = "sha256-F56Rr7MjKUkoik4YbeROsL7/tqKVKDvr9K81o2s4Czw=";
      por = "sha256-AWxqNxux5MSP5SGQjPO6PXUfreCrhGrV1AhrVj9cUow=";
      pus = "sha256-uQ/O5S4DoeeMvN0yz7SLx94izFb6xa1CoAodYqelL0Y=";
      que = "sha256-ZaWf96rz505Z3GX/fNyBZQMab8+V0lv21Fy2mKKrcwc=";
      ron = "sha256-FTyCyAcYUpiDqeeREJCAJL72KFXZ1aC38lkPy4De5ik=";
      rus = "sha256-aBviwr6tG8e9I134jETo5grnOuhmhAwK1OO0wke9N8I=";
      san = "sha256-XR/UK1JNC5krfDuYyknbFu+mxPE30r2CY5gXVvLEl+I=";
      sin = "sha256-xCQWB6/iV7nP2vpaFxKHt9BEH/VB47IUwPoDVYkW7SQ=";
      slk = "sha256-M0U5fhZJqntniIoZKPBNGIeeB0a9AKOq/w06F8u9JzE=";
      slk_frak = "sha256-cT7dJUQ5cueNftGCoAPfGcGz+N8tvmv4pR+FF6rSO5o=";
      slv = "sha256-TvPT/0JarymFq5MlYjpZ34y9KtQqP8g+eQ3cUiqVhBg=";
      snd = "sha256-ZyoVGmnKGp79/Ygbt6tHmUnhU0nHS/tt2oOSQEh0VcQ=";
      spa = "sha256-Cw/LtGZRieAauAGeWR8BTdcmBGDeByVD7dSyy07efJY=";
      spa_old = "sha256-Q2XJ2WyFEkVVinKuuF4NIEQGsFKrjgWd5TWPWAkDCMs=";
      sqi = "sha256-ARyC6wqo2VQ7CdeRS1W5Kxs08s1PxMTINSClD3vcm6U=";
      srp = "sha256-FPCNtRrj6luycyu0jAmVWQDYqsFGrv+G0n0bOIItosk=";
      srp_latn = "sha256-P8I6VlHDejPY4t0GDEHh+/JiNQkUtaRqqQv8Yes55cw=";
      sun = "sha256-6oaA9XYmP6G0TACWl6ZuMoVaEZ7JmAR2WSdvJwdXdFM=";
      swa = "sha256-4EMKiLBjLTub/5b7qkUjOfxC0HyA/AAz/r8FdQvDyWM=";
      swe = "sha256-JOLdFcwAiNIRxfG9SZceYAMX8gFQLerbxBfw/9bJpvg=";
      syr = "sha256-aHg+E1WKiTXpzJ2+GeJUutUUwfe8Z5/hk+CEHbUr0u0=";
      tam = "sha256-rrrgRz04udD5znUYO0M0gwvKuu+A3Q3Au1AocO1qEGY=";
      tat = "sha256-5lyctRvEfR7td2FWPjLTCDL+OqrCsy72jp5cf9HN5Cg=";
      tel = "sha256-fQkoEoidyLsfQtk7jZj2mFJ4AJ4xztMP9DTuDjtEmD0=";
      tgk = "sha256-xzgovz+eBvpBwH95mCmwHU7ODj3SmUyRTWQ+M8F8qJA=";
      tgl = "sha256-dnJiuUmQHqczAjmZ8bLUUfD+ggBBZr1rEHT4Nhln2os=";
      tha = "sha256-iAMqnyGsz/gl767SlgTrilNOJlz4BYqV6lQXpt+RwAU=";
      tir = "sha256-06XlsFwn4iCV6xxxJwasvkn5bQQC3xFOKRsyGRYi3OA=";
      ton = "sha256-uK3o84oF7AaFs+3rRb4NGgMCtyZtZ1yjkkj7jNQD5hk=";
      tur = "sha256-SJuVBOgNcYTtGsmhl2ZHiE7nEUnaIx/zwsHcFTcPLz0=";
      uig = "sha256-iBTbyJjNR7k3nLBpEGSsAit5QcjYN2HgHWpwGkSXSic=";
      ukr = "sha256-ZAyfvaGsRdHIh0HvAcaIwzdVnDf1Y8NuYufl+ZCmCJM=";
      urd = "sha256-gLwoL7uumavWtAcITEAakw3cSTQ3GRCeZQ13lTH8epc=";
      uzb = "sha256-9jx8jWFvVOiIMJ8E6vVWgof0CsqlTU40zlHWrTbgHg4=";
      uzb_cyrl = "sha256-B6vbCeDHm5FE3SL94BBlUqwyFhBMEwVmWM9RcXOmY5A=";
      vie = "sha256-Fk2b7X5aZERYbTlDTMGt9N+XbP4jz/1kaOREyUcDZAo=";
      yid = "sha256-H1AC4G/G7jOuvJJZb9u8ofDF5RqKi/PwVTjsTkDcy3Y=";
      yor = "sha256-m35CeoAKh2Rg8CDVaDgCkuIm1i/4pOutieZZUSJTgx8=";
    };
  };
}
