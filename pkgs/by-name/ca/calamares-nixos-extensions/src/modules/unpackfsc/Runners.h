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

#include <QObject>

class Runner : public QObject
{
    Q_OBJECT

public:
    Runner( const QString& source, const QString& destination );
    ~Runner() override;

    virtual Calamares::JobResult run() = 0;

Q_SIGNALS:
    // Progress?

protected:
    QString m_source;
    QString m_destination;
};

class FSArchiverRunner : public Runner
{
public:
    using Runner::Runner;

    Calamares::JobResult run() override;
};

class UnsquashRunner : public Runner
{
public:
    using Runner::Runner;

    Calamares::JobResult run() override;
};


#endif
