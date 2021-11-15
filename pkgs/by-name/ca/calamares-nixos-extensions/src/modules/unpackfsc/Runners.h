/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#ifndef UNPACKFSC_RUNNERS_H
#define UNPACKFSC_RUNNERS_H

#include <Job.h>

class Runner : public QObject
{
    Q_OBJECT

public:
    Runner( const QString& source, const QString& destination );
    ~Runner() override;

    virtual Calamares::JobResult run() = 0;

    /** @brief Check that the (configured) source file exists.
     *
     * Returns @c true if it's a file and readable.
     */
    bool checkSourceExists() const;

    /** @brief Check that a named tool (executable) exists in the search path.
     *
     * Returns @c true if the tool is found and sets @p fullPath
     * to the full path of that tool; returns @c false and clears
     * @p fullPath otherwise.
     */
    static bool checkToolExists( const QString& toolName, QString& fullPath );

Q_SIGNALS:
    // See Calamares Job::progress
    void progress( qreal percent, const QString& message );

protected:
    QString m_source;
    QString m_destination;
};

#endif
