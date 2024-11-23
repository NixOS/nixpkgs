{ runCommandLocal, maid }:

runCommandLocal "test-maid-run" {
  nativeBuildInputs = [ maid ];
}
  ''
    mkdir -p $out/test
    export HOME=$out
    cd $out
    touch test/a.iso test/b.txt
    cat > rules.rb <<EOF
      Maid.rules do
        rule 'ISO' do
          trash(dir('test/*.iso'))
        end
      end
    EOF
    maid clean --rules rules.rb --force
    [ -f test/b.txt ] && [ ! -f test/a.iso ]
  ''
