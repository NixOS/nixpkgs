% From: https://en.wikipedia.org/wiki/TXL_(programming_language)

%Syntax specification
define program
   [number]
end define

%Transformation rules
function main
   replace [program]
       p [number]
   by
       p [fact][fact0]
end function

function fact
   replace [number]
      n [number]
   construct nMinusOne [number]
      n [- 1]
   where
      n [> 1]
   construct factMinusOne [number]
      nMinusOne [fact]
   by
      n [* factMinusOne]
end function

function fact0
 replace [number]
      0
 by
      1
end function
