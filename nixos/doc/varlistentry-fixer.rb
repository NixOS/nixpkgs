#!/usr/bin/env ruby

# This script is written intended as a living, evolving tooling
# to fix oopsies within the docbook documentation.
#
# This is *not* a formatter. It, instead, handles some known cases
# where something bad happened, and fixing it manually is tedious.
#
# Read the code to see the different cases it handles.
#
# ALWAYS `make format` after fixing with this!
# ALWAYS read the changes, this tool isn't yet proven to be always right.

require "rexml/document"
include REXML

if ARGV.length < 1 then
	$stderr.puts "Needs a filename."
	exit 1
end

filename = ARGV.shift
doc = Document.new(File.open(filename))

$touched = false

# Fixing varnames having a sibling element without spacing.
# This is to fix an initial `xmlformat` issue where `term`
# would mangle as spaces.
#
#   <varlistentry>
#    <term><varname>types.separatedString</varname><replaceable>sep</replaceable> <----
#    </term>
#    ...
#
# Generates: types.separatedStringsep
#                               ^^^^
#
# <varlistentry xml:id='fun-makeWrapper'>
#  <term>
#   <function>makeWrapper</function><replaceable>executable</replaceable><replaceable>wrapperfile</replaceable><replaceable>args</replaceable>  <----
#  </term>
#
# Generates: makeWrapperexecutablewrapperfileargs
#                     ^^^^      ^^^^    ^^  ^^
#
#    <term>
#     <option>--option</option><replaceable>name</replaceable><replaceable>value</replaceable> <-----
#    </term>
#
# Generates: --optionnamevalue
#                   ^^  ^^
doc.elements.each("//varlistentry/term") do |term|
	["varname", "function", "option", "replaceable"].each do |prev_name|
		term.elements.each(prev_name) do |el|
			if el.next_element and
					el.next_element.name == "replaceable" and
					el.next_sibling_node.class == Element
				then
				$touched = true
				term.insert_after(el, Text.new(" "))
			end
		end
	end
end



#  <cmdsynopsis>
#   <command>nixos-option</command>
#   <arg>
#    <option>-I</option><replaceable>path</replaceable>        <------
#   </arg>
#
# Generates: -Ipath
#             ^^
doc.elements.each("//cmdsynopsis/arg") do |term|
	["option", "replaceable"].each do |prev_name|
		term.elements.each(prev_name) do |el|
			if el.next_element and
				el.next_element.name == "replaceable" and
				el.next_sibling_node.class == Element
			then
				$touched = true
				term.insert_after(el, Text.new(" "))
			end
		end
	end
end

#  <cmdsynopsis>
#   <arg>
#    <group choice='req'>
#    <arg choice='plain'>
#     <option>--profile-name</option>
#    </arg>
#
#    <arg choice='plain'>
#     <option>-p</option>
#    </arg>
#     </group><replaceable>name</replaceable>   <----
#   </arg>
#
# Generates: [{--profile-name | -p }name]
#                                   ^^^^
doc.elements.each("//cmdsynopsis/arg") do |term|
	["group"].each do |prev_name|
		term.elements.each(prev_name) do |el|
			if el.next_element and
				el.next_element.name == "replaceable" and
				el.next_sibling_node.class == Element
			then
				$touched = true
				term.insert_after(el, Text.new(" "))
			end
		end
	end
end


if $touched then
	doc.context[:attribute_quote] = :quote
	doc.write(output: File.open(filename, "w"))
end
