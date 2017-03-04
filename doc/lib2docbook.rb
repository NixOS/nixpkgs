require "json"
documented_functions = JSON.load(STDIN.read)


puts <<EOF
<chapter xmlns="http://docbook.org/ns/docbook"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         xml:id="chap-lib-functions">

<title>Library functions</title>
<para>This paragraph describes the available library functions.</para>
EOF

puts <<EOF
<section xml:id="sec-lib-functions-top-level">
<title>Top level functions</title>
<para>These functions are available under <varname>pkgs.lib</varname></para>
<variablelist>
EOF

documented_functions["topLevel"].each do |function|
  puts <<-EOF
    <varlistentry>
      <term><option>#{function["name"].join(".")}</option></term>
      <listitem>
      <para>
        #{function["docs"]["description"]}
      </para>
      #{function["docs"]["examples"].map do |example|
        "<para><emphasis>Example:</emphasis><programlisting>#{example}</programlisting></para>"
        end.join("\n")
      }
      </listitem>
    </varlistentry>
  EOF
end

puts "</variablelist></section>"

puts <<EOF
<section xml:id="sec-lib-functions-all">
<title>All library functions</title>
<para>These functions are available under <varname>pkgs.$category.$name</varname></para>
<variablelist>
EOF

documented_functions["categorized"].each do |function|
  puts <<-EOF
    <varlistentry>
      <term><option>#{function["name"].join(".")}</option></term>
      <listitem>
      <para>
        #{function["docs"]["description"]}
      </para>
      #{function["docs"]["examples"].map do |example|
        "<para><emphasis>Example:</emphasis><programlisting>#{example}</programlisting></para>"
        end.join("\n")
      }
      </listitem>
    </varlistentry>
  EOF
end

puts "</variablelist></section>"
puts "</chapter>"
