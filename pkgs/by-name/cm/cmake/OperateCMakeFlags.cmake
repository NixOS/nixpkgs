function(join_list_string_inners LEFT RIGHT OUTPUT)
  if (LEFT STREQUAL "")
    set(${OUTPUT} "${RIGHT}" PARENT_SCOPE)
  elseif (RIGHT STREQUAL "")
    set(${OUTPUT} "${LEFT}" PARENT_SCOPE)
  else()
    set(${OUTPUT} "${LEFT},${RIGHT}" PARENT_SCOPE)
  endif()
endfunction()

function(_encode_json_string INPUT_STRING OUTPUT)
  string(JSON OUTPUT_JSON STRING_ENCODE "${INPUT_STRING}")
  set(${OUTPUT} "${OUTPUT_JSON}" PARENT_SCOPE)
endfunction()

string(TOUPPER "${OPERATION}" OPERATION)

if (NOT DEFINED ATTRIBUTE_NAME)
  set(ATTRIBUTE_NAME "cmakeFlags")
endif()

if (NOT DEFINED IGNORE_NULL)
  set(IGNORE_NULL true)
endif()

if (NOT DEFINED ENCODE_NEW_ELEMENTS)
  set(ENCODE_NEW_ELEMENTS true)
endif()

file(READ $ENV{NIX_ATTRS_JSON_FILE} ATTRS_JSON_STRING)
string(JSON JSON_LIST_STRING ERROR_VARIABLE ERROR_VAR GET_RAW "${ATTRS_JSON_STRING}" ${ATTRIBUTE_NAME})

if (NOT ERROR_VAR STREQUAL "")
  set(JSON_LIST_STRING "[]")
else()
  string(JSON JSON_LIST_TYPE "${JSON_LIST_STRING}")
  if (JSON_LIST_TYPE STREQUAL "NULL")
    set(JSON_LIST_STRING "[]")
  elseif(NOT JSON_LIST_TYPE STREQUAL "ARRAY")
    message(FATAL_ERROR "OperateCMakeFlags: Unexpected cmakeFlags JSON type ${JSON_LIST_TYPE}.")
  endif()
endif()
string(STRIP "${JSON_LIST_STRING}" JSON_LIST_STRING)

string(JSON CURRENT_LENGTH LENGTH "${JSON_LIST_STRING}")
math(EXPR CURRENT_LENGTH_M1 "${CURRENT_LENGTH} - 1")

string(LENGTH "${JSON_LIST_STRING}" JSON_LIST_STRING_LENGTH)

if (OPERATION STREQUAL "PREPEND" OR OPERATION STREQUAL "APPEND")

  if (NOT DEFINED NEW_ELEMENTS)
    message(FATAL_ERROR "OperateCMakeFlags: Operation PREPEND and APPEND requires variable NEW_ELEMENTS")
  endif()

  if (ENCODE_NEW_ELEMENTS)
    list(TRANSFORM NEW_ELEMENTS APPLY _encode_json_string)
  endif()
  list(JOIN NEW_ELEMENTS "," NEW_ELEMENTS_JOINED)

  math(EXPR JSON_LIST_STRING_INNER_LENGTH "${JSON_LIST_STRING_LENGTH} - 2")
  string(SUBSTRING "${JSON_LIST_STRING}" 1 "${JSON_LIST_STRING_INNER_LENGTH}" JSON_LIST_STRING_INNER)
  unset(JSON_LIST_STRING_INNER_LENGTH)
  string(STRIP "${JSON_LIST_STRING_INNER}" JSON_LIST_STRING_INNER)

  if (OPERATION STREQUAL "APPEND")
    join_list_string_inners("${JSON_LIST_STRING_INNER}" "${NEW_ELEMENTS_JOINED}" JSON_LIST_STRING_INNER)
  else()
    join_list_string_inners("${NEW_ELEMENTS_JOINED}" "${JSON_LIST_STRING_INNER}" JSON_LIST_STRING_INNER)
  endif()
  set(JSON_LIST_STRING "[${JSON_LIST_STRING_INNER}]")
  unset(JSON_LIST_STRING_INNER)

elseif(OPERATION MATCHES "^REMOVE_")

  if (NOT DEFINED PATTERN)
    message(FATAL_ERROR "OperateCMakeFlags: Operation REMOVE_* requires variable PATTERN")
  endif()

  if ("${CURRENT_LENGTH}" EQUAL 0)
    message(debug "OperateCMakeFlags: ${OPERATION}: ${ATTRIBUTE_NAME} has 0 element, doing nothing.")
  else()

    if (OPERATION STREQUAL "REMOVE_EQUAL")
      set(_KEYWORD "STREQUAL")
    elseif (OPERATION STREQUAL "REMOVE_MATCH")
      set(_KEYWORD "MATCHES")
    else()
      message(FATAL_ERROR "OperateCMakeFlags: Unsupported operation ${OPERATION}")
    endif()

    foreach(IDX RANGE "${CURRENT_LENGTH_M1}" 0 -1)
      if (IGNORE_NULL)
        string(JSON ELEMENT_TYPE TYPE "${JSON_LIST_STRING}" "${IDX}")
        if (ELEMENT_TYPE STREQUAL NULL)
          continue()
        endif()
      endif()
      string(JSON ELEMENT GET "${JSON_LIST_STRING}" "${IDX}")
      if (ELEMENT ${_KEYWORD} "${PATTERN}")
        string(JSON JSON_LIST_STRING REMOVE "${JSON_LIST_STRING}" "${IDX}")
      endif()
    endforeach()

  endif()

else()
  message(FATAL_ERROR "OperateCMakeFlags: Unsupported operation ${OPERATION}")
endif()

string(JSON ATTRS_JSON_STRING SET "${ATTRS_JSON_STRING}" ${ATTRIBUTE_NAME} "${JSON_LIST_STRING}")
file(WRITE $ENV{NIX_ATTRS_JSON_FILE} "${ATTRS_JSON_STRING}")
