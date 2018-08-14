================================================================================
Canon CAPT Printer Driver for Linux Version 2.71



                   必 ず お 読 み く だ さ い
================================================================================

□  商標について

  Adobe、Acrobat、Acrobat Reader、PostScript およびPostScript 3は、
  Adobe Systems Incorporated（アドビ システムズ社）の商標です。
  Linux は、Linus Torvalds の商標です。
  OpenOffice.org and the seagull logo are registered trademarks of The 
  Apache Software Foundation.
  UNIX は、The Open Group の米国およびその他の国における登録商標です。
  その他、本文中の社名や商品名は、各社の商標です。


□  目次

ご使用になる前に
  1.はじめに
  2.Canon CAPT Printer Driver for Linuxの配布ファイル構成
  3.プリンタドライバの使用環境
  4.ccpdデーモンの自動起動の設定方法
  5.使用上の注意
  6.付録


1.はじめに ---------------------------------------------------------------------

  このたびは「Canon CAPT Printer Driver for Linux」をご利用いただきまして、
  誠にありがとうございます。
  本プリンタドライバは、Linux OS上の印刷システムであるCUPS（Common Unix Printing
  System）環境で動作するキヤノンLBPプリンタ製品に対応する印刷機能を提供する
  ドライバです。


2.Canon CAPT Printer Driver for Linuxの配布ファイル構成 ------------------------

  Canon CAPT Printer Driver for Linuxの配布ファイルは、以下のとおりです。
  なお、CUPSドライバ共通モジュールおよびプリンタドライバモジュールのファイル名
  は、お使いのバージョンによって異なります。

  - README-capt-2.7xJ.txt（本ドキュメント）
    Canon CAPT Printer Driver for Linuxの使用上の注意、補足情報について記載
    しています。

  - LICENSE-captdrv-2.7xJ.txt
    Canon CAPT Printer Driver for Linuxの使用許諾契約書です。

  - guide-capt-2.7xJ.tar.gz
    Canon CAPT Printer Driver for Linuxの利用方法を記したオンラインマニュアル
    です。
    Canon CAPT Printer Driver for Linuxの動作環境・インストール方法・使用方法に
    ついては、こちらに記載しています。
    圧縮ファイルになっていますので、任意のディレクトリに解凍してご参照ください。

  - cndrvcups-common-3.21-x.i386.rpm（32-bit用）
  - cndrvcups-common-3.21-x.x86_64.rpm（64-bit用）
  - cndrvcups-common_3.21-x_i386.deb（Debian 32-bit用）
  - cndrvcups-common_3.21-x_amd64.deb（Debian 64-bit用）
    Canon CAPT Printer Driver for Linuxで用いる、CUPSドライバ共通モジュールの
    インストールパッケージです。

  - cndrvcups-capt-2.71-x.i386.rpm（32-bit用）
  - cndrvcups-capt-2.71-x.x86_64.rpm（64-bit用）
  - cndrvcups-capt_2.71-x_i386.deb（Debian 32-bit用）
  - cndrvcups-capt_2.71-x_amd64.deb（Debian 64-bit用）
    Canon CAPT Printer Driver for Linux のインストールパッケージです。

  - cndrvcups-common-3.21-x.tar.gz
    Canon CAPT Printer Driver for Linuxで用いる、CUPSドライバ共通モジュールの
    ソースファイルです。

  - cndrvcups-capt-2.71-x.tar.gz
    Canon CAPT Printer Driver for Linuxのソースファイルです。


3.プリンタドライバの使用環境 ---------------------------------------------------

  本プリンタドライバは以下の環境でご使用ください。

  ・ハードウェア
      x86互換の32-bit CPUまたは64-bit CPUを搭載し、Linuxが動作するコンピュータ

  ・対象プリンタ
      本プリンタドライバが対応する機種は、以下のとおりです。
      お使いのプリンタに対応するドライバ名とPPDファイルについては、こちらを
      参照してください。

      Canon LBP9200C（CNCUPSLBP9200CCAPTJ.ppd）
      LBP9200C

      Canon LBP9100C（CNCUPSLBP9100CCAPTJ.ppd）
      LBP9100C

      Canon LBP7200C（CNCUPSLBP7200CCAPTJ.ppd）
      LBP7200C、LBP7200CN

      Canon LBP7010C（CNCUPSLBP7010CCAPTJ.ppd）
      LBP7010C

      Canon LBP6340（CNCUPSLBP6340CAPTJ.ppd）
      LBP6340、LBP6330

      Canon LBP6300（CNCUPSLBP6300CAPTJ.ppd）
      LBP6300

      Canon LBP6200（CNCUPSLBP6200CAPTJ.ppd）
      LBP6200

      Canon LBP5300（CNCUPSLBP5300CAPTJ.ppd）
      LBP5300
 
      Canon LBP5100（CNCUPSLBP5100CAPTJ.ppd）
      LBP5100

      Canon LBP5050（CNCUPSLBP5050CAPTJ.ppd）
      LBP5050、LBP5050N

      Canon LBP5000（CNCUPSLBP5050CAPTJ.ppd）
      LBP5000

      Canon LBP3600（CNCUPSLBP3600CAPTJ.ppd）
      LBP3600

      Canon LBP3500（CNCUPSLBP3500CAPTJ.ppd）
      LBP3500

      Canon LBP3310（CNCUPSLBP3310CAPTJ.ppd）
      LBP3310

      Canon LBP3300（CNCUPSLBP3300CAPTJ.ppd）
      LBP3300

      Canon LBP3210（CNCUPSLBP3210CAPTJ.ppd）
      LBP3210

      Canon LBP3200（CNCUPSLBP3200CAPTJ.ppd）
      LBP3200

      Canon LBP3100（CNCUPSLBP3100CAPTJ.ppd）
      LBP3100

      Canon LBP3000（CNCUPSLBP3000CAPTJ.ppd）
      LBP3000

      Canon LBP-1210（CNCUPSLBP1210CAPTJ.ppd）
      LBP-1210

      Canon LBP-1120（CNCUPSLBP1120CAPTJ.ppd）
      LBP-1120

  インストール方法および具体的なご利用方法に関しましては、オンラインマニュアルを
  ご覧ください。


4.ccpdデーモンの自動起動の設定方法 ---------------------------------------------

  ステータスモニタの自動起動の設定を行う場合、ccpdデーモンを自動起動するように
  設定しておく必要があります。
  以下の手順にしたがって、ccpdデーモンを自動起動するように設定してください。

  ■ /etc/rc.local ファイルがあるディストリビューションの場合
    rootでログインし、/etc/rc.local ファイルに/etc/init.d/ccpd startのコマンドを
    追加してください。

  ■ /sbin/insserv コマンドがあるディストリビューションの場合
    rootでログインし、/etc/init.d/ccpd の3行目に以下のコメントを追加して、
    insserv ccpd コマンドを実行してください。

    ### BEGIN INIT INFO
    # Provides:          ccpd
    # Required-Start:    $local_fs $remote_fs $syslog $network $named
    # Should-Start:      $ALL
    # Required-Stop:     $syslog $remote_fs
    # Default-Start:     3 5
    # Default-Stop:      0 1 2 6
    # Description:       Start Canon Printer Daemon for CUPS
    ### END INIT INFO

  ■ /usr/bin/systemctl コマンドがあるディストリビューションの場合
    rootでログインし、エディタで/etc/rc.local ファイルを作成して、
    以下の内容を追加してください。
      #!/bin/sh 
      /etc/init.d/ccpd start

    その後、以下のコマンドを実行して、/erc/rc.d/rc.localファイルの
    パーミッションを変更してください。
      # chmod 777 /etc/rc.d/rc.local


5.使用上の注意 -----------------------------------------------------------------

- cndrvcups-commonパッケージのバージョン3.21をインストールする場合、
  cndrvcups-captパッケージのバージョン2.71をインストールしてお使いください。

- OpenOffice.orgおよびStarSuiteより［ページレイアウト］で複数ページ/枚を
  指定した場合、CUPSモジュールの動作原因により、正しく複数ページ割り付けされて
  出力されません。

- OpenOffice.orgおよびStarSuiteより部数指定をして作成したPostScriptファイルは、
  ドライバ画面の［プリンタ選択／印刷設定］ページ内の［印刷部数］で指定した値では
  なく、PostScriptファイル作成時の部数を反映して出力します。

- プリント処理中にドライバ画面より設定内容を変更した場合、印刷結果は変更後の
  設定内容を反映したものになります。

- OpenOffice.org、GIMP、Acrobat Reader v5.0などのアプリケーションより
  ［印刷全般］ページの［明るさ/ガンマ補正設定］を指定した場合、設定内容は
  有効になりません。

- デスクトップまたはコマンドライン上から、PDF書類を直接指定して印刷することは
  できません。PDF書類を印刷するときは、Acrobat ReaderまたはAdobe Readerより
  印刷することを推奨いたします。

- Linux以外のOS環境で作成されたPDF書類をAcrobat Readerより印刷する場合、
  PDFファイル中で使用されている和文フォントによっては、正しい印刷結果が
  得られない場合があります。

- 印刷時プリントキューの最大保持数は、CUPSの動作原因により500未満です。
  500番目以降のプリントキューは破棄されます。

- アプリケーションより用紙サイズを指定した場合、設定内容は有効になりません。
  ドライバ画面の［印刷全般］ページの［原稿サイズ］で指定した値を反映して出力
  します。

- SUSE LINUX Professional 9.3 をお使いの場合、ドライバ画面が文字化けする
  場合があります。この問題は、以下の方法で回避できます。
  1） rootでログインする
  2） 以下のコマンドを実行して、GTK+の環境設定を変更する
     # cd  /etc/
     # ln  -s  opt/gnome/gtk  ./

- SUSE LINUX Professional 9.3 をお使いの場合、ドライバ画面を起動すると、
  ワーニングが発生する場合があります。この問題は、以下の方法で回避できます。
  1）［Kメニュー］ ->［コントロールセンター］を起動する
  2）［外観＆テーマ］を選択する
  3）［色］を選択する
  4）［非KDEアプリケーションにも色設定を適用］のチェックをオフにする
  5）［コントロールセンター］を閉じる

- LBP9200C、LBP9100C、LBP7200C、LBP7200CN、LBP7010C、LBP6340、LBP6330、LBP6300、
  LBP6200、LBP5300、LBP5100、LBP5050、LBP5050N、LBP5000、LBP3500、LBP3310、
  LBP3300、LBP3100をお使いの場合、Glue Codeの動作原因により、印刷するジョブに
  白紙ページがあっても白紙ページは出力されません。
  ［仕上げ詳細］ダイアログボックスの［白紙節約モードを使う］を「オフ」に指定
  したり、コマンドライン上から白紙節約モードを使用しない指定をしても設定は
  有効になりません。

- LBP5300をネットワーク環境でご使用になる場合、ネットワークボードのファーム
  ウェアのバージョンが1.10以降でないと正常に動作しません。
  キヤノンホームページ（http://canon.jp/）から、最新のアップデートファイル
  をダウンロードして、ファームウェアを更新してください。

- LBP5000、LBP3500、LBP3300にNB-C1を装着してネットワーク環境でご使用になる場合、
  ネットワークボードのファームウェアのバージョンが1.30以降でないと正常に動作しま
  せん。
  キヤノンホームページ（http://canon.jp/）から、最新のアップデートファイル
  をダウンロードして、ファームウェアを更新してください。

- LBP3310にNB-C2を装着してネットワーク環境でご使用になる場合、ネットワークボード
  のファームウェアのバージョンが1.30以降でないと正常に動作しないことがあります。
  キヤノンホームページ（http://canon.jp/）から、最新のアップデートファイルを
  ダウンロードして、ファームウェアを更新してください。

- プリンタ本体のジョブキャンセルキーにてジョブをキャンセルした場合、データサイズ
  によってはCUPSのジョブが残ることがあります。その場合は、CUPS画面などでジョブを
  削除してください。

- localhostのIPアドレスが参照できない場合、ステータスモニタを起動することはでき
  ません。
  localhostのIPアドレスが参照できるように、"/etc/hosts"を修正してください。

- Fedora CoreにてHALデーモンを動作させている環境で、プリンタをUSBケーブルで接続
  した場合、HALデーモンがプリンタ名を用いて生成する登録プリンタエントリを一度
  削除してから、プリンタの登録操作を行ってください。

- 印刷システムにCUPS 1.2.xをお使いの場合、バナー付き印刷が正しく動作しない場合が
  あります。
  バナー付き印刷を行う場合は、印刷システムをCUPS 1.1.xに入替えてお使いください。

- 以下のディストリビューションをご使用の場合、「libstdc++.so.5」が標準で
  インストールされていないため、プリンタドライバのインストールが失敗する可能性が
  あります。
  この場合、パッケージの追加インストールを行ってください。
  - Fedora Core 4、Fedora Core 5、Fedora Core 6、Fedora 7、Fedora 8、Fedora 9、
    Fedora 10、Fedora 11、Fedora 12、Fedora 13、Fedora 14、
    RedHat Enterprise Linux 5.1、CentOS 5.3
    -> パッケージ（compat-libstdc++-33）をインストールしてください。
  - Ubuntu 7.10、Ubuntu 8.04、Ubuntu 8.10、Ubuntu 9.04、Ubuntu 9.10、
    Ubuntu 10.04、Ubuntu 10.10、Debian GNU/Linux 4.0、Debian GNU/Linux 5.0
    -> パッケージ（gcc-3.3-base、libstdc++5）を
       http://lug.mtu.edu/ubuntu/pool/main/g/gcc-3.3/
       から取得して、インストールしてください。
       参考情報：http://ubuntuforums.org/showthread.php?t=674100
  - openSUSE 11.1
    -> パッケージ（libstdc++33-.3.3-7.5.i586）をインストールしてください。

- SUSE Linux 9.3、SUSE Linux 10.0をお使いの場合、MozillaまたはFireFoxで［印刷］
  ダイアログボックスから印刷をするときに、複数部数を指定しても、設定内容は
  有効にならず、1部しか印刷されません。
  この問題は、/etc/cups/mime.convsファイルの下記の行を以下のとおりに変更する
  ことで回避できます。
  ［修正前］
    application/mozilla-ps application/postscript 33 pswrite
  ［修正後］
    application/mozilla-ps application/postscript 33 pstops

- Fedora 8、Fedora 9をお使いの場合、［印刷全般］ページの［バナーページ印刷設定］
   - ［印刷終了］で［none］以外を指定すると、印刷キューが停止します。

- Fedora 9をお使いの場合、CCPDデーモンの再起動を行うと、カーネルが停止する
  場合があります。
  この問題は、カーネルを「kernel-2.6.25.14-108.fc9」にアップデートすること
  で回避できます。

- Fedora 11をお使いの場合、ジョブをキャンセルして印刷キューが停止した状態で印刷
  を行うと、ジョブが保留されます。
  このような場合は、CUPSWebインタフェースのプリンタの状態にある［メンテナンス］
  ボタンをクリックして、［プリンタを開始］を選択すると、［保留中］のジョブが
  再実行されます。
  ［メンテナンス］ボタンが無い場合は、［プリンタを停止］を選択すると
  ［プリンタを開始］が選択できます。

- openSUSE 10.2およびSLED10SP1に含まれるGhostscriptのバージョンが8.15.3の
  システムをお使いの場合、印刷できない文書があります。他のバージョンの
  Ghostscriptを入手してください。

- openSUSE 11.0でGhostscriptのバージョンが8.6.xのシステムをお使いの場合、
  EvinceやGIMPなどのアプリケーションから印刷するときに時間がかかる場合が
  あります。

- Adobe Reader 7.0.xの印刷画面で「用紙サイズ」「給紙部」「両面印刷」などの
  指定を行った場合、プリンタコマンドにコマンドオプションとして指定した項目が
  自動的に付加されますが、コマンドオプションとして正しく認識できないため、
  指定した項目は無効となります。
  指定を有効にして印刷する場合、プリンタコマンドのコマンドオプションを以下の
  ように"-o"で１つ１つのオプションを区切るように指定してください。
  （変更前） -o InputSlot=Manual,Duplex=DuplexNotumble
  （変更後） -o InputSlot=Manual -o Duplex=DuplexNoTumble

- Adobe Reader 8からPDFを印刷した場合、一部の画像データが印刷されない場合が
  あります。
  この問題は、Adobe Reader 7またはAdobe Reader 9を使用するか、PostScript 
  オプションをレベル3に設定して印刷することで回避できる場合があります。

- Adobe Reader 8.1.2の印刷画面のプロパティで［両面印刷（短辺とじ）］を指定して
  印刷すると、［両面印刷（長辺とじ）］で印刷されます。
  この問題は、cngplpから印刷することによって回避できます。

- Vine Linux 3.1をお使いの場合、Adobe Reader 7.0.9からの印刷に時間がかかったり、
  印刷できない文書があります。

- Vine Linux 4.1をお使いの場合、コマンドラインから日本語を含むPDFを印刷すると、
  Ghostscriptが不正終了するためPDF印刷が止まる場合があります。
  この問題は、Adobe Readerを使用することにより回避できます。

- Vine Linux 4.1をお使いの場合、Adobe Reader 8からPDFファイルを印刷すると、
  Adobe Reader 8が作成するPSファイルをGhostscript（7.07）が解析できず
  異常終了し、 フィルタ処理が終了するため、キューが停止することがあります。
  この問題は、Adobe Reader 7を使用することで回避できます。

- Vine Linux 4.1、Vine Linux 4.2、Fedora 8、Fedora 9、およびRedHat Enterprise
  Linux v.5をお使いの場合、CUPSフィルタが常にポートレイトでPSコマンドを
  作成するため、テキストファイルの印刷において、ランドスケープ指定時に向きが
  ポートレイトとなり、印字が欠けているような印刷結果となることがあります。
  また、CUPS標準フィルタのtexttopsで提供される機能は正しく動作しないことが
  あります。
  この問題は、CUPS設定ファイルmime.convsのtext/plain行で指定されているCUPS
  フィルタ名を、CUPS標準フィルタのtexttopsに変更することで回避できます。
  その場合、日本語テキストは文字化けしますので、テキストエディタやpapsなどの
  テキスト・ポストスクリプト変換プログラムで作成したPSコマンドを印刷する必要が
  あります。

- OpenOffice.orgのWriterなどのアプリケーションの印刷画面で給紙部を指定した場合、
  指定は無効となり、ドライバ画面で設定した給紙部を使って印刷されます。
  給紙部を指定して印刷するには、ドライバ画面で指定するか、コマンドラインから
  印刷してください。

- Debian GNU/Linux 4.0をお使いの場合、プリンタ登録時にppdファイルエラーと
  なる場合があります。プリンタ登録コマンドのppd指定に"-m"の代わりに
  "-P（ppdのフルパス）"を使用してください。
    例： /usr/sbin/lpadmin -p LBP5000
          -P /usr/share/cups/model/CNCUPSLBP5000CAPTJ.ppd
          -v ccp://localhost:59687 -E

- Debian GNU/Linux 4.0 r6をお使いの場合、ロケールにEUC-JPが設定されているときに
  cngplpからテキストファイルを印刷すると、印刷に失敗します。
  この問題は、テキストエディタやpapsなどのテキスト・ポストスクリプト変換
  プログラムで作成したPSコマンドを印刷することで回避できます。

- Debian GNU/Linux 5.0.2をお使いの場合、共通モジュールをインストールするために
  gs-espモジュールが必要となります。
  以下のコマンドを実行することでgs-espモジュールをインストールできます。
    # apt-get install gs-esp

- Ubuntu 7.04およびDebian GNU/Linux 4.0をお使いの場合、ドライバ画面などが文字
  化けする場合があります。/etc/gtk/gtkrc.jaファイルを/etc/gtk/gtkrc.ja.utf8
  としてコピーし、作成したgtkrc.ja.utf8ファイルの1行目と最終行を以下のように
  書き換えてください。
    ［修正前］ gtk-default-ja
    ［修正後］ gtk-default-ja-utf8

- Ubuntu 7.10をお使いの場合、AppArmorと呼ばれるセキュリティ対応ソフトが導入
  されているため、印刷に失敗する場合があります。
  回避策として、sudo aa-complain cupsdを実行し、AppArmorのCUPSプロファイルを
  止める事により、印刷可能となります。
  詳しくは、Ubuntu 7.10のリリースノートを参照してください。

- Fedora 19、Fedora 20、Fedora 21、Ubuntu 8.10、Ubuntu 9.04、Ubuntu 9.10、
  Ubuntu 10.04、Ubuntu 10.10、Ubuntu 11.04、Ubuntu 11.10、Ubuntu 12.04、
  Ubuntu 14.04、Ubuntu 14.10をお使いの場合、排紙方法を指定して印刷しても、
  デフォルトの排紙方法で印刷されます。
  この問題は、CUPSプリンタ設定（Web）から排紙方法の設定を変更することで
  回避できます。

- Ubuntu 8.10をお使いの場合、逆順印刷を指定して印刷しても、印刷結果に反映
  されません。
  この問題は、CUPSをアップデートすることで回避できます。

- Ubuntu 8.10、Ubuntu 9.04、Ubuntu 9.10、Ubuntu 10.04、Ubuntu 10.10、
  Ubuntu 11.04、Ubuntu 11.10、Ubuntu 12.04、Ubuntu 14.04、Ubuntu 14.10を
  お使いの場合、PDFデータおよびPSデータを印刷するときに明るさとガンマ補正を
  指定して印刷しても、印刷結果に反映されない場合があります。

- Ubuntu 7.04、Ubuntu 7.10、Ubuntu 8.04、Ubuntu 8.10、Ubuntu 9.04、
  Debian GNU/Linux 3.1、Debian GNU/Linux 4.0、Debian GNU/Linux 5.0をお使いの
  場合、共通モジュールをインストールするためにlibcupsys2ライブラリが必要に
  なります。
  システムにインストールされていない場合、以下のコマンドを実行することで
  インストールできます。
  # apt-get install libcupsys2

- Ubuntu 9.04をお使いの場合、CUPSのバージョンを「1.3.9-17ubuntu3.2」に
  アップデートすると、PSデータ不正のため印刷に失敗します。
  この問題は、CUPSのバージョンを「1.3.9-17ubuntu3.1」にダウングレードすることで
  回避できます。
  ＜apt-getコマンドでダウングレードする場合＞
    - 以下のコマンドを実行します。
        # apt-get install cups=1.3.9-17ubuntu3.1

- Ubuntu 9.04、Ubuntu 9.10、Ubuntu 10.04、Ubuntu 10.10、Ubuntu 11.04、
  Ubuntu 11.10、Ubuntu 12.04、Ubuntu 14.04、Ubuntu 14.10、Fedora 11、Fedora 12、
  Fedora 13、Fedora 14、Fedora 15、Fedora 16、Fedora 17、Fedora 18、Fedora 19、
  Fedora 20、Fedora 21で、バナー印刷をした場合、指定部数分バナーページが印刷
  されます。

- USB接続で同一のデバイスパス（/dev/usb/lp0など）を使用して複数台のプリンタを
  使用する場合は、接続を切り替える際に、ccpdデーモンを停止してからプリンタを
  追加してください。
  ccpdデーモンを停止しないと、正しい印刷結果が得られない場合があります。

- Linuxのホスト名に15文字以上の文字列が設定されていると、ステータスモニタに
  ステータスが正しく表示されない場合があります。

- 同一機種のプリンタに対して、1台のコンピュータをUSBとネットワークの両方で接続
  すると、ステータスモニタにステータスが正しく表示されない場合があります。

- Ghostscriptのバージョンが8.6xの場合、印刷できない文書があります。

- CentOS 5.3をお使いの場合、Evinceで複数部数を指定して印刷しても、指定した部数
  どおりに印刷されません。この問題は、Adobe ReaderなどのほかのPDFビューアから
  印刷を行うか、以下の方法で回避できます。
  1）Evinceで、部数を1部、出力先にPSコマンドを選択して、ファイルを出力します。
  2）ファイル出力したPSコマンドを、cngplpで部数を指定して印刷します。

- プリンタドライバを1.90以前のバージョンから、バージョン2.70以降にアップデート
  インストールする場合、アップデートインストール前に登録されているプリンタは、
  再登録する必要があります。

- debパッケージのプリンタドライバを1.90以前のバージョンから、バージョン2.70以降に
  アップデートインストールする場合、インストールパッケージに含まれる"ccpd.conf"
  をインストールするかを確認するメッセージがコンソールに表示されることが
  あります。
  その場合、インストールパッケージに含まれる"ccpd.conf"をインストールして
  ください。

- GTK（GIMP Toolkit）のバージョンにより、画面の文字が欠けて表示される場合が
  ありますが、機能や設定される値には問題ありません。該当する文言領域を再描画
  すると回復します。

- Fedora 12、Ubuntu 9.10をお使いの場合、CUPSのWebインタフェースからの
  デフォルトオプションを変更すると、各機能間の設定に競合が発生しているのにも
  かかわらず、デフォルト値が保存されます。また、一度競合が発生した状態で保存
  されると、Webインタフェースで競合が発生しない正しい値に設定しても保存
  できません。
  この状態で［cngplp］ダイアログボックスを表示すると、不正な動作をする場合が
  あります。
  この問題は、以下の方法で回避できます。
  【回避策1】Fedora 12（32-bit/64-bit）、Ubuntu 9.10
    不正な動作をしたプリンタを再登録することで正常な状態に戻ります。
  【回避策2】Fedora 12（32-bit/64-bit）
    以下のコマンドでCUPS をアップデートすることで回避できます。
    <Fedora 12(32-bit）の場合> # yum update cups.i686
    <Fedora 12(64-bit）の場合> # yum update cups.x86_64

- 64-bit 環境で本ドライバをお使いの場合、ドライババージョン2.20から、ドライバ
  バージョン2.30以降へアップデートインストールすると、印刷時にエラーが起こる
  ことがあります。
  この問題は、本ドライバをアンインストール（rpm -e <ドライバ>）した後に、再度
  ドライバをインストール（rpm -i <ドライバ>）することで復旧できます。
  また、アップデートインストールを行わずに古いバージョンのドライバを
  アンインストール（rpm -e <ドライバ>）した後、新しいバージョンのドライバを
  インストール（rpm -i <ドライバ>）することで回避できます。

- Fedora 13/14/15/16/17/18/19/20/21 32-bit/64-bitからの印刷について
  cngplpやコマンドラインから、TIFF、JPEG画像ファイルを印刷した場合、印刷画像が
  崩れることがあります。
  本現象は当該ディストリビューションに依存する問題です。
  この問題は、以下の方法で回避できます。
  【回避策】
    GIMP等のアプリからPostScriptファイル出力を行い、その後にファイル出力した
    当該PSコマンドをcngplpにて印刷することで回避できます。

- Fedora 12/13/14/15/16/17/18/19/20/21からの明るさ、ガンマ補正の設定について
  cngplpやコマンドラインから、明るさ、ガンマ補正を指定しても、2ページ目以降の
  印刷結果に反映されないことがあります。
  本現象は、アプリケーションが生成するPostScriptデータを、Ghostscriptが正しく
  認識できていないため、これらの機能が有効となりません。

- Fedora 15/16/17/18/19/20/21からの印刷について
  Fedora 15/16/17/18/19/20/21でcngplpからポートレートのPDFデータをデフォルトの
  ままで印刷を行った場合、画像が用紙からはみ出る（縦向きの用紙に横向きの画像が
  印刷される）ことがあります。
  【回避策1】
    Adobe Readerなどのアプリケーションから印刷する。
  【回避策2】
    Adobe ReaderなどのアプリケーションからPSデータ化し、そのPSデータを
    cngplpから印刷する。

- Ubuntu 11.04/11.10/12.04/14.04/14.10、Fedora 15/16/17/18/19/20/21での明るさの
  設定について
  Ubuntu 11.04/11.10/12.04/14.04/14.10およびFedora 15/16/17/18/19/20/21で、
  明るさ9から0を指定して印刷した場合、明るさの設定が有効にならず、明るさ100を
  指定した場合と同等の印刷結果となります。

- Ubuntu 10.10/11.04/11.10/12.04/14.04/14.10、Fedora 14/15/16/17/18/19/20/21での
  デフォルト原稿サイズについて
  Ubuntu 10.10/11.04/11.10/12.04/14.04/14.10、Fedora 14/15/16/17/18/19/20/21に
  おいて、US仕向けのプリンタを登録した場合に、原稿サイズのデフォルトがA4になる
  場合があります。
  以下の方法でプリンタを登録することで回避できます。
  【回避策1】
     lpadminコマンドのPPDファイルを指定するオプションに、"-m"でなく"-P"を
     指定して登録してください。（"-P"でPPDを指定する場合、指定する
     PPDファイルへのパスは絶対パス、または相対パスを指定してください。）
       例：# /usr/sbin/lpadmin -p ［登録プリンタ名］ -P ［PPD ファイルパス］
           -v lpd:［デバイス URI］ -E
  【回避策2】
     "/etc/cups/cupsd.conf"に、"DefaultPaperSize Auto"を追加して、CUPSを
     再起動してプリンタを登録してください。

- TIFF、JPEG画像の印刷について
  cngplpやコマンドラインからTIFF、JPEG画像を印刷した場合、画像が分割されて
  複数ページ印刷されることがあります。
  【回避策】
    GIMP等のアプリからPostScriptファイル出力を行い、その後にファイル出力した
    当該PSコマンドをcngplpやコマンドラインにて印刷することで回避できます。

- Ubuntu 11.10/12.04/14.04/14.10からの印刷について
  Ubuntu 11.10/12.04/14.04/14.10でcngplpからPDFを印刷すると、原稿サイズの設定が
  有効とならず、PDFに埋め込まれている原稿サイズに丸め込まれて印刷される場合が
  あります。
  このような場合は、Adobe Readerなどのアプリケーションから印刷してください。

- Ubuntu 11.10/12.04/14.04/14.10での用紙サイズ表示について
  Ubuntu 11.10/12.04/14.04/14.10でcngplpのコンボボックスを操作するときに、
  スライダーが表示された状態で項目を選択すると、UI操作が行えなくなる場合が
  あります。
  このような場合は、ESCキーを押してください。

- Ubuntu 11.10からのUSB接続プリンタとの通信について
  Ubuntu 11.10で、OS起動時に"usblp"が起動していないために、USB接続のプリンタと
  通信ができない場合があります。
  この問題は、以下の方法で回避できます。
  【回避策1】
    OS起動時に毎回以下のコマンドを実行し、"usblp"モジュールを読み込む。
    #sudo modprobe usblp
  【回避策2】
    /etc/modprobe.d/blacklist-cups-usblp.confから"blacklist usblp"の行を
    削除し、OS起動時に"usblp"モジュールの読み込みを抑止する設定を解除する。

- 本プリンタドライバが1台のPCに登録できるプリンタは、16台までとなります。

- Ubuntu 12.04/14.04/14.10の「LibreOffice」からの印刷について 
  Ubuntuの LibreOffice を使用して WindowsOffice フォーマット(*.doc など)の
  データを印刷した場合、印刷結果が崩れたり、印刷できない場合があります。   
  本現象は、アプリケーションが生成する PostScriptデータを、Ghostscriptが正しく
  認識できていないためです。   

  【回避策 1】   
     Windows の Office フォーマット(*.doc など)を LibreOffice フォーマット 
     (*.odt など)に変換後、Print ダイアログを開き、[Printer Language type]を
     [PDF] 以外に選択し、印刷を行うと回避できます。
  【回避策 2】   
     LibreOfficeから [Printer Language type] を[PDF]以外に選択後、
     PostScriptファイル出力を行い、その後にファイル出力した当該PSコマンドを
     cngplpにて印刷することで回避できます。 

- Ubuntu 12.04/14.04/14.10の ccpd の再起動について
  Ubuntu 12.04/14.04/14.10において、以下のコマンドを実行しても、ccpd が再起動
  しないことがあります。
  このような場合は、もう一度コマンドを実行してください。
    # /etc/init.d/ccpd restart

  また、以下のコマンドを続けて入力する場合、ccpd が再起動しないことがあります。
    # /etc/init.d/ccpd stop 
    # /etc/init.d/ccpd start
  このような場合は、ccpd 停止コマンド入力後、しばらく待ってから ccpd 起動
  コマンドを入力してください。

- Ubuntu 12.04をお使いの場合、同じデータを連続で印刷すると、2回目以降のデータが
  正常に印刷されない場合があります。
  以下のコマンドでCUPSをアップデートすることで回避できます。
    # apt-get install cups
    # apt-get install libcups2

- Ubuntu 14.04、Fedora 19/20/21をお使いの場合、［cngplp］ダイアログボックスや
  コマンドラインからバナーページ印刷設定でstandard、classified、secret、
  confidential、topsecret、unclassifiedを選択しても、印刷結果に反映されません。

- Ubuntu 14.04/14.10、Fedora 19/20/21 におけるバナー印刷時の他ジョブの割り込み
  について
  バナーページ印刷中に他ジョブがデバイスに送信された場合、デバイスがジョブを
  受け取るタイミングによってはバナーページと本文の間に他ジョブが割り込まれて
  印刷される場合があります。

- PDFに含まれる画像を印刷する場合、pdftopsが利用するプログラムによっては、
  正しく印刷できない場合があります。
  以下のコマンドで、利用するプログラムを変更することで回避できることがあります。
  <ghostscriptのpdftopsをお使いの場合>
    # lpadmin -p [登録プリンタ名] -o pdftops-renderer-default=pdftops

  <popplerのpdftopsをお使いの場合>
    # lpadmin -p [登録プリンタ名] -o pdftops-renderer-default=gs

- ［cngplp］ダイアログボックスやコマンドラインから、TIFF 画像ファイルを印刷した
  場合、画像によっては印字結果が黒で塗りつぶされる場合があります。
  【回避策1】
    GIMP等のアプリから印刷することで回避できます。
  【回避策2】
    PostScriptファイル出力を行った後、ファイル出力した当該PSファイルを［cngplp］
    ダイアログボックスから印刷することで回避できます。

- Ubuntu 14.04/14.10をお使いの場合、［cngplp］ダイアログボックスやコマンドライン
  からマルチバイト文字コードを含むテキストデータを印刷すると、文字化けすることが
  あります。
  この問題は、geditなどのテキストエディタから印刷することで回避できます。

-［cngplp］ダイアログボックスやコマンドラインから、PDF画像ファイルを印刷した
  場合、画像によっては印字結果が黒で塗りつぶされる場合があります。
  【回避策】
    Adobe Reader 9を使用できる環境にある場合、印刷時に［詳細設定］ダイアログ
    ボックスで、［プリンターによるカラー指定］または［画像として印刷］に
    チェックマークをつけることで回避できることがあります。

- Fedora 19、Ubuntu 14.10 でのプリンタ登録方法について
  Fedora 19、Ubuntu 14.10 からlpadmin コマンドにてプリンタキューを作成するとき、
  "-m" オプションを利用すると、一般ユーザ権限では[cngplp]ダイアログボックスに
  キューが表示されない場合があります。
  【回避策】
    lpadminコマンドのPPDファイルを指定するオプションに、”-m”でなく”-P”を
    指定して登録してください。
    ※ ”-P”でPPDを指定する場合、指定するPPDファイルへのパスは絶対パス、
       または相対パスを指定してください。

      例:
      # /usr/sbin/lpadmin -p [登録プリンタ名] -P [PPDファイルパス]
        -v lpd:[デバイスURI] -E

- Deb パッケージのアップデートインストールについて
  Ver.2.60 以前のバージョンから、Ver.2.70 以降にアップデートインストールする
  場合、ファイル競合によりインストールエラーとなります。
  以下のオプション指定でアップデートインストールを実施してください。
    # dpkg -i --force-overwrite <ドライバモジュールのファイル名>

- ccpd の起動について
  ccpd デーモンを起動した場合、以下のエラーが表示されることがあります。
    Starting ccpd (via systemctl):    Failed to start ccpd.service:
    Unit ccpd.service failed to load: No such file or directory.

  エラーが発生した場合は、以下のコマンドを実行してからccpd デーモンを起動
  してください。
    # systemctl daemon-reload

- Fedora 21からのテキスト印刷について
  1行の長さが用紙幅を越えている場合、用紙幅に合わせて改行されますが、改行された
  部分の文字間隔が詰まって印刷される場合があります。
  【回避策】
    geditなどのテキストエディタから印刷することで回避できます。

- Fedoraをお使いの場合、必要なパッケージが不足しているためドライバをインストール
  できない場合があります。その場合、以下のコマンドでパッケージを追加することで
  回避できます。
  <Fedora 10（64-bit）の場合> 
    # yum install glibc.i386
    # yum install libxml2.i386
    # yum install compat-libstdc++-33-3.2.3-64.i386

  <Fedora 11（64-bit）の場合>
    # yum install glibc.i586
    # yum install libxml2.i586
    # yum install compat-libstdc++-33-3.2.3-64.i586

  <Fedora 12/13/14（64-bit）の場合>
    # yum install glibc.i686
    # yum install libgcc.i686
    # yum install libstdc++.i686
    # yum install compat-libstdc++-33-3.2.3-64.i686
    # yum install popt.i686
    # yum install libxml2.i686

  <Fedora 15/16/17（64-bit）の場合>
    # yum install glibc.i686
    # yum install libgcc.i686
    # yum install libstdc++.i686
    # yum install popt.i686
    # yum install libxml2.i686

  <Fedora 18/19/20/21（64-bit）の場合> 
    # yum install pangox-compat 
    # yum install glibc.i686 *
    # yum install libgcc.i686 *
    # yum install libstdc++.i686 *
    # yum install popt.i686 *
    # yum install libxml2.i686 *

  * 同名の64-bitライブラリ(最新バージョン)のインストールが必要となる場合が
    あります。
    例：”yum install glibc.i686”でライブラリのインストールに失敗した場合、
        ”yum install glibc”で64-bitのglibcライブラリをインストールしたあとに
        ”yum install glibc.i686”を実行すると、回避できる場合があります。

  <Fedora 18/19/20/21（32-bit）の場合>
    # yum install pangox-compat

- Ubuntuをお使いの場合、デフォルト設定でインストールしたとき、必要なライブラリが
  ないため、ドライバをインストールできない場合があります。以下のコマンドで
  ライブラリをインストールすることで回避できます。
  <Ubuntu 12.04/14.04/14.10（32-bit）の場合>
    # apt-get install libglade2-0

  <Ubuntu 12.04（64-bit）の場合>
    # apt-get install libglade2-0
    # apt-get install ia32-libs
    # apt-get install libpopt0:i386

  <Ubuntu 14.04/14.10（64-bit）の場合>
    # apt-get install libglade2-0
    # apt-get install libxml2:i386
    # apt-get install libstdc++6:i386
    # apt-get install libpopt0:i386

- 本プリンタドライバを使用するためには、共通APIを含んだGhostscriptが必要です。
  ドライバをインストールする前に、Ghostscriptがインストールされているか確認して
  ください。GNOME Terminalなどのターミナルソフトで次のコマンドを用いて確認する
  ことができます。
    % gs -h | grep opvp
  表示結果にopvpとoprpが表示されている場合は、共通APIを含んだGhostscriptが
  組込まれています。
  何も表示されなかったときは、下記URLを参照してGhostscriptを入手してください。
  http://opfc.sourceforge.jp/index.html.en


6.付録 -----------------------------------------------------------------

  以下はライセンスモジュールの一覧です。

別表1

c3pldrv
libc3pl.so.0.0.1
libcaepcm.so.1.0
libcaiousb.so.1.0.0
libcaiowrap.so.1.0.0
libcanon_slim.so.1.0.0
libColorGear.so.0.0.0
libColorGearC.so.0.0.0
CANSRGBA.ICC
CNZ005.ICC
CNZ006.ICC
CNZ007.ICC
CNZ008.ICC
CNZ055.ICC
ccpd.conf
ccpd(デーモン本体)
captdrv
captfilter
captmon
captmon2
captmonlbp3300
captmonlbp5000
captmoncnab6
captmoncnab7
captmoncnab8
captmoncnab9
captmoncnaba
captmoncnabb
captmoncnabc
captmoncnabd
captmoncnabe
captmoncnabf
captmoncnabg
captmoncnac5
captmoncnac6
captmoncnac8
captmoncnac9
captmoncnaca
captmoncnacb
captmoncnacc
captmoncnacd
libcaiocaptnet.so.1.0.0
libcaptfilter.so.1.0.0
libcnaccm.so.1.0
libcncaptnpm.so.2.0.1
CNC610A.ICC
CNC610B.ICC
CNC710A.ICC
CNC710B.ICC
CNC711A.ICC
CNC711B.ICC
CNC810A.ICC
CNC810B.ICC
CNC910A.ICC
CNC910B.ICC
CNCA10A.ICC
CNCA10B.ICC
CNCB10A.ICC
CNCB10B.ICC
CNCC10A.ICC
CNCC10B.ICC
CNCD11A.ICC
CNCD11B.ICC
CNCE10A.ICC
CNCE10B.ICC
CNCF10A.ICC
CNCF10B.ICC
CNCG10A.ICC
CNCG10B.ICC
CNCH10A.ICC
CNCH10B.ICC
CNCI10A.ICC
CNCI11B.ICC
CNCJ10A.ICC
CNCJ10B.ICC
CNL610A.ICC
CNL610B.ICC
CNL611A.ICC
CNL611B.ICC
CNL760A.ICC
CNL760B.ICC
CNL810A.ICC
CNL810B.ICC
CNL820A.ICC
CNL820B.ICC
CNL821A.ICC
CNL821B.ICC
CNL960A.ICC
CNL960B.ICC
CNL980A.ICC
CNL980B.ICC
CNLA60A.ICC
CNLA60B.ICC
CNLA80A.ICC
CNLA80B.ICC
CNLB10A.ICC
CNLB10B.ICC
CNLC10A.ICC
CNLC10B.ICC
CNLD10A.ICC
CNLD10B.ICC
CNLD80A.ICC
CNLD80B.ICC
CNLE60A.ICC
CNLE60B.ICC
CNLF10A.ICC
CNLF10B.ICC
CNLG10A.ICC
CNLG10B.ICC
CNLH60A.ICC
CNLH60B.ICC
CNLH80A.ICC
CNLH80B.ICC
CNLI10A.ICC
CNLI10B.ICC
CnAC076D.DAT
CnAC0999.DAT
CnAC25C8.DAT
CnAC2849.DAT
CnAC29A9.DAT
CnAC4739.DAT
CnAC7AA5.DAT
CnACB5C9.DAT
CnACB81B.DAT
CnACB848.DAT
CnACD891.DAT
CnACE599.DAT
CnACE8E8.DAT
CnACF0F1.DAT
CnAC_04A.DAT
CnAC_09A.DAT
CnAC_14A.DAT
CnAC_17A.DAT
CnAC_20A.DAT
CnAC_22A.DAT
CnAC_23A.DAT
CnAC_31A.DAT
CnAC_33A.DAT
CnABFINK.DAT
CnAC8INK.DAT
CnAC9INK.DAT
CnACAINK.DAT
CnACBINK.DAT
CnACCINK.DAT
CnACDINK.DAT
ccpd(デーモン起動/停止用スクリプト)
ccpdadmin
msgtablelbp3300.xml
msgtablelbp5000.xml
msgtablecnab6.xml
msgtablecnab7.xml
msgtablecnab8.xml
msgtablecnab9.xml
msgtablecnaba.xml
msgtablecnabb.xml
msgtablecnabc.xml
msgtablecnabd.xml
msgtablecnabe.xml
msgtablecnabf.xml
msgtablecnabg.xml
msgtablecnac5.xml
msgtablecnac6.xml
msgtablecnac8.xml
msgtablecnac9.xml
msgtablecnaca.xml
msgtablecnacb.xml
msgtablecnacc.xml
msgtablecnacd.xml
msgtable.xml
msgtable2.xml
CNAB1CL.BIN
CNAB7CL.BIN
CNABBCL.BIN
CNABBCLS.BIN
CNABECL.BIN
CNABGCL.BIN
CNAC4CL.BIN
CNAC5CL.BIN
CNAC6CL.BIN
CNAC8CL.BIN
CNAC8CR.BIN
CNAC8DH.BIN
CNAC9CL.BIN
CNAC9CLS.BIN
CNAC9CR.BIN
CNAC9DH.BIN
CNACACL.BIN
CNACACR.BIN
CNACADH.BIN
CNACBCL.BIN
CNACCCL.BIN
CNACCCR.BIN
CNACCDH.BIN
CNACDCL.BIN
CNACDCR.BIN
CNACDDH.BIN
cnab6cl.bin


別表2

cnusb
cngplp
cnjatool
cngplp.mo
cngplp.glade
ccp
pstocapt
pstocapt2
pstocapt3
captstatusui
captstatusui.mo
libuictlcapt.la
libuictlcapt.so.1.0.0
libuictlcapt.1.0.mo
cngplp_capt.glade
func_config_capt.xml
*.res
*.ppd


別表3

buflist.h
buftool.h
libbuftool.a
libcanoncapt.la
libcanoncapt.so.1.0.0
libcanonc3pl.so.1.0.0


================================================================================
お客様相談窓口
================================================================================
    本ソフトウェア、および付随する情報等は、 キヤノンが独自に開発し、
    キヤノンマーケティングジャパンが配布するものです。 本ソフトウェア、および
    付随する情報等に対応するプリンタの製造元であるキヤノン、配布元である
    キヤノンマーケティングジャパンは、本ソフトウェア、および付随する情報等に
    関するお問い合わせは受け付けておりません。 なお、プリンタの修理、または
    消耗品の購入等、プリンタ本体に関する問い合わせは、キヤノンマーケティング
    ジャパンにお願いいたします。
================================================================================
                                                       Copyright CANON INC. 2013
